resource "random_pet" "this" {}

resource "aws_cloudfront_function" "modify_response_headers" {
  name    = "modify-response-headers-${random_pet.this.id}-${var.environment}"
  runtime = "cloudfront-js-2.0"
  publish = true

  code = <<-EOF
    function handler(event) {
      var response = event.response;
      var headers = response.headers;

      headers['strict-transport-security'] = { value: 'max-age=63072000; includeSubdomains; preload' };
      headers['content-security-policy'] = { value: "default-src 'self' https://fonts.gstatic.com; connect-src 'self' https://eu.i.posthog.com; img-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; script-src 'self' 'unsafe-inline' https://assets.mailerlite.com/js/universal.js https://eu.i.posthog.com https://eu-assets.i.posthog.com; object-src 'none'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'; frame-src 'self' https://calendar.google.com" };
      headers['x-content-type-options'] = { value: 'nosniff' };
      headers['x-frame-options'] = { value: 'DENY' };
      headers['x-xss-protection'] = { value: '1; mode=block' };
      headers['referrer-policy'] = { value: 'same-origin' };

      return response;
    }
  EOF
}

resource "aws_cloudfront_function" "domain_redirect" {
  count = var.domain_redirect != null ? 1 : 0

  name    = "domain-redirect-${random_pet.this.id}-${var.environment}"
  runtime = "cloudfront-js-2.0"
  publish = true

  code = <<-EOF
    var defined = ${jsonencode(var.domain_redirect)};

    function handler(event) {
      var request = event.request;
      var host = request.headers.host.value;

      if (host === defined.from || host.endsWith('.' + defined.from)) {
        var newHost = host.replace(defined.from, defined.to);
        return {
          statusCode: 301,
          statusDescription: 'Moved Permanently',
          headers: {
            location: { value: 'https://' + newHost + request.uri }
          }
        };
      }

      return request;
    }
  EOF
}
