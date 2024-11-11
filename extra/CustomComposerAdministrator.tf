# environment permissions such as create/update and delete were removed
resource "google_organization_iam_custom_role" "CustomComposerAdministrator" {
  role_id = "CustomComposerAdministrator"
  title   = "Custom Composer Administrator"
  # ORG LEVEL
  org_id      = "<your org id>"
  description = "Custom role created by terraform. Environment permissions such as create/update and delete were removed"
  permissions = ["composer.dags.execute", "composer.dags.get", "composer.dags.getSourceCode", "composer.dags.list", "composer.environments.executeAirflowCommand", "composer.environments.get",
    "composer.environments.list", "composer.imageversions.list", "composer.operations.delete", "composer.operations.get", "composer.operations.list", "composer.userworkloadsconfigmaps.create",
    "composer.userworkloadsconfigmaps.delete", "composer.userworkloadsconfigmaps.get", "composer.userworkloadsconfigmaps.list", "composer.userworkloadsconfigmaps.update", "composer.userworkloadssecrets.create", "composer.userworkloadssecrets.delete",
  "composer.userworkloadssecrets.get", "composer.userworkloadssecrets.list", "composer.userworkloadssecrets.update", "serviceusage.quotas.get", "serviceusage.services.get", "serviceusage.services.list"]
}