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
      headers['content-security-policy'] = { value: "default-src 'self' https://fonts.gstatic.com; img-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; script-src 'self' 'unsafe-inline' https://assets.mailerlite.com/js/universal.js https://eu.i.posthog.com https://eu-assets.i.posthog.com; object-src 'none'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'; frame-src 'self' https://calendar.google.com" };
      headers['x-content-type-options'] = { value: 'nosniff' };
      headers['x-frame-options'] = { value: 'DENY' };
      headers['x-xss-protection'] = { value: '1; mode=block' };
      headers['referrer-policy'] = { value: 'same-origin' };

      return response;
    }
  EOF
}
