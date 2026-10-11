variable "network_services_tcp_routes" {
  description = <<EOT
Map of network_services_tcp_routes, attributes below
Required:
    - name
    - rules (block):
        - action (required, block):
            - destinations (optional, block):
                - service_name (optional)
                - weight (optional)
            - idle_timeout (optional)
            - original_destination (optional)
        - matches (optional, block):
            - address (required)
            - port (required)
Optional:
    - deletion_policy
    - description
    - gateways
    - labels
    - meshes
    - project
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    name            = string
    deletion_policy = optional(string)
    description     = optional(string)
    gateways        = optional(list(string))
    labels          = optional(map(string))
    meshes          = optional(list(string))
    project         = optional(string)
    rules = list(object({
      action = object({
        destinations = optional(list(object({
          service_name = optional(string)
          weight       = optional(number)
        })))
        idle_timeout         = optional(string)
        original_destination = optional(bool)
      })
      matches = optional(list(object({
        address = string
        port    = string
      })))
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.network_services_tcp_routes : (
        length(v.rules) >= 1
      )
    ])
    error_message = "Each rules list must contain at least 1 items"
  }
  # Note: 1 additional provider-side validator is enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

