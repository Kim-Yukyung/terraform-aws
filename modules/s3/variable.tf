variable "prefix" {
  description = "모든 리소스 이름 앞에 붙일 공통 접두사"
  type        = string
}

variable "source_files_path" {
  description = "S3에 업로드할 정적 파일이 있는 디렉토리 경로"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "모든 리소스에 공통으로 적용할 태그 맵"
  type        = map(string)
  default     = {}
}
