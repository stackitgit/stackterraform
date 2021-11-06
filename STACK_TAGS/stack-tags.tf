locals {
# server_tags=merge(

# )

all_resource_tags=merge(
var.required_tags,
var.tag_sets,)
}