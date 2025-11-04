workspace "Engineering Home" "Project Context OS architecture" {

	model {
		user = person "Developer" "Engineers using the workspace"

		contextOS = softwareSystem "Project Context OS" "Provides visibility, search, and documentation across all repos" {
			backstage = container "Backstage" "Developer Portal" "Node.js" "Web Browser" {
				catalog = component "Catalog" "Service registry"
				techdocs = component "TechDocs" "Documentation renderer"
				scaffolder = component "Scaffolder" "Template engine"
			}

			sourcegraph = container "Sourcegraph" "Code Intelligence" "Go" "Web Browser" {
				search = component "Search Engine" "Code search"
				codeIntel = component "Code Intel" "Definitions and references"
			}

			structurizr = container "Structurizr Lite" "Architecture Diagrams" "Java" "Web Browser"

			mkdocs = container "MkDocs" "Documentation Site" "Python" "Web Browser"
		}

		repos = softwareSystem "Repositories" "Git repositories containing applications and libraries" {
			apps = container "Applications" "Service repos" "Various"
			libs = container "Libraries" "Shared code" "Various"
			templates = container "Templates" "Starter kits" "Various"
		}

		user -> backstage "Discovers services and docs"
		user -> sourcegraph "Searches code"
		user -> structurizr "Views architecture"
		user -> mkdocs "Reads documentation"

		backstage -> repos "Catalogs"
		sourcegraph -> repos "Indexes"
		mkdocs -> repos "Renders docs from"
		structurizr -> repos "Reads DSL from"

		catalog -> techdocs "Renders docs for services"
		search -> codeIntel "Enhances search with"
	}

	views {
		systemContext contextOS "SystemContext" {
			include *
			autoLayout
		}

		container contextOS "Containers" {
			include *
			autoLayout
		}

		component backstage "BackstageComponents" {
			include *
			autoLayout
		}

		component sourcegraph "SourcegraphComponents" {
			include *
			autoLayout
		}

		styles {
			element "Software System" {
				background #1168bd
				color #ffffff
			}
			element "Container" {
				background #438dd5
				color #ffffff
			}
			element "Component" {
				background #85bbf0
				color #000000
			}
			element "Person" {
				shape person
				background #08427b
				color #ffffff
			}
			element "Web Browser" {
				shape WebBrowser
			}
		}

		theme default
	}

}
