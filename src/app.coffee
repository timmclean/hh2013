TEMPLATE_NAMES = [
	'formPage',
	'formPageDomain',
	'formPageAddFocus',
	'formPageFocus',
	'formPageFocusEdit',
]

DEFAULT_DOMAIN_NAMES = [
	"Risk"
	"Psychiatric"
	"Medications"
	"Medical Concerns / Tests / Procedures"
	"Addictions"
	"Health Teaching"
	"Activity/Diet/Nutrition/Sleep"
	"Family / Community"
	"Reintegration / Spirituality"
	"Legal / Housing / Employment / Education"
	"Treatment Goals"
	"Discharge Planning"
]
 
DEFAULT_FOCUS = {
	description: ''
	solution: ''
	initials: ''
}

templates = null

compileTemplates = ->
	templates = {}

	for templateName in TEMPLATE_NAMES
		source = $("script.#{templateName}.template").html()
		templates[templateName] = Handlebars.compile source

addFocus = (domainDom) ->
	domainDom.find('.focuses').append templates.formPageFocus DEFAULT_FOCUS
	editFocus domainDom.find('.focuses > .focus').last()

editFocus = (focusDom) ->
	focus = serializeFocus focusDom
	focusDom.before templates.formPageFocusEdit focus
	newFocusDom = focusDom.prev()
	focusDom.remove()

	newFocusDom.find('button.save').click (event) ->
		saveFocus $(event.target).parents('.focus')

	newFocusDom.find('button.delete').click (event) ->
		$(event.target).parents('.focus').remove()

saveFocus = (focusDom) ->
	focus = serializeFocus focusDom
	console.log focus
	focusDom.before templates.formPageFocus focus
	newFocusDom = focusDom.prev()
	focusDom.remove()

	newFocusDom.click (event) ->
		editFocus $(this)

serializeCarePlan = (carePlanDom) ->
	# TODO

serializeFocus = (focusDom) ->
	getTextOrValue = (selector) ->
		dom = focusDom.find(selector)
		return dom.val() or dom.text()

	return {
		description: getTextOrValue('.description')
		solution: getTextOrValue('.solution')
		initials: getTextOrValue('.initials')
	}

showFormPage = (filePath) ->
	carePlan = {
		patient: {
			name: "John Smith"
			jNumber: "123"
		}
		domains: ({name, focuses: []} for name in DEFAULT_DOMAIN_NAMES)
	}

	$('.page').html templates.formPage(carePlan)

	domainHtml = ''

	for domain in carePlan.domains
		domainHtml += templates.formPageDomain domain

	$('.page > .domains').html domainHtml

	for domain, domainIndex in carePlan.domains
		domainDom = $($('.page > .domains > .domain')[domainIndex])

		if domain.focuses.length
			focusHtml = ''

			for focus in domain.focuses
				focusHtml += templates.formPageFocus focus

			domainDom.children('.focuses').html focusHtml
			domainDom.find('.focuses > .focus').each ->
				# Activates click listeners, etc
				saveFocus $(this)

		domainDom.append templates.formPageAddFocus()

	$('.page .domain > .addFocus').click (event) ->
		domainDom = $(this).parent()
		addFocus domainDom

	$('.page .domain > .add').click (event) ->

$ ->
	compileTemplates()
	showFormPage('somewhere')
