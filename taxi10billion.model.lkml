connection: "retail-block-connection"

include: "*.view.lkml"         # include all views in this project
# include: "*.dashboard.lookml"  # include all dashboards in this project

explore: taxi10billion {
  label: "NYC Taxi Data 🚕"
}
