resource "vault_policy" "azure" {
  name = "azure_sp"
  policy = "${file("./policies/azure_sp")}"
}
