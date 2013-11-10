TEMPLATE_NAMES = ['formPage', 'formPageDomain']

templates = null

compileTemplates = ->
	templates = {}

	for templateName in TEMPLATE_NAMES
		source = $("script.#{templateName}.template").html()
		templates[templateName] = Handlebars.compile source

showFormPage = (filePath) ->
	carePlan = {
		patient: {
			name: "John Smith"
			jNumber: "123"
		}
		domains: [
			{
				name: "Risk"
				focuses: [
					{
						timestamp: "2013-11-09T16:04Z"
						description: "Suicide risk"
						solution: "Put on drug X"
						initials: "tm"
					}
					{
						timestamp: "2013-11-08T17:02Z"
						description: "Suicide risk"
						solution: "Talked about stuff and yeah"
						initials: "tm"
					}
				]
			}
			{
				name: 'Medications'
				focuses: []
			}
		]
	}

	$('.page').html templates.formPage(carePlan)

	domainHtml = ''

	for domain in carePlan.domains
		domainHtml += templates.formPageDomain(domain)

	$('.page > .domains').html domainHtml

	$('.page .domain > .empty').click (event) ->
		$(this).remove()

		# TODO

$ ->
	compileTemplates()
	showFormPage('somewhere')
