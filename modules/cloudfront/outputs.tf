output "cloudfront_distribution_domain_name" {
  type        = string
  description = "The domain name of the CloudFront distribution (e.g., d111111abcdef8.cloudfront.net)."
  value       = aws_cloudfront_distribution.main.domain_name
}
