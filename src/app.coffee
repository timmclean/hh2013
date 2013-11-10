fs = require 'fs'

TEMPLATE_NAMES = [
	'formPage',
	'formPageDomain',
	'formPageFocus',
	'formPageFocusRev',
	'newPatientPage',
]

DEFAULT_DOMAIN_NAMES = [
	"Risk"
	"Psychiatric"
	"Medications"
	"Medical Concerns / Tests / Procedures"
	"Addictions"
	"Health Teaching"
	"Activity / Diet / Nutrition / Sleep"
	"Family / Community"
	"Reintegration / Spirituality"
	"Legal / Housing / Employment / Education"
	"Treatment Goals"
	"Discharge Planning"
]
 
DEFAULT_FOCUS_REVISION = {
	description: ''
	solution: ''
	initials: ''
}

DEFAULT_FOCUS = {
	revisions: [DEFAULT_FOCUS_REVISION]
}

templates = null

compileTemplates = ->
	templates = {}

	for templateName in TEMPLATE_NAMES
		source = $("script.#{templateName}.template").html()
		templates[templateName] = Handlebars.compile source

editFocus = (focusDom) ->
	focus = serializeFocus focusDom
	focusDom.before templates.formPageFocusEdit focus
	newFocusDom = focusDom.prev()
	focusDom.remove()

	newFocusDom.find('button.save').click (event) ->
		event.preventDefault()

		saveFocus $(event.target).parents('.focus')

	newFocusDom.find('button.delete').click (event) ->
		event.preventDefault()

		$(event.target).parents('.focus').remove()

saveFocus = (focusDom) ->
	focus = serializeFocus focusDom
	console.log focus
	focusDom.before templates.formPageFocus focus
	newFocusDom = focusDom.prev()
	focusDom.remove()

	newFocusDom.click (event) ->
		event.preventDefault()

		editFocus $(this)

serializeCarePlan = (carePlanDom) ->
	# TODO

serializeFocusRevision = (focusRevDom) ->
	return {
		timestamp: focusRevDom.data('timestamp')
		description: focusRevDom.find('.description').val()
		solution: focusRevDom.find('.solution').val()
		initials: focusRevDom.find('.initials').val()
	}

deserializeCarePlan = (carePlan, parentDom) ->
	parentDom.html templates.formPage carePlan

	domainsDom = parentDom.find('.domains')
	for domain in carePlan.domains
		deserializeDomain domain, domainsDom

deserializeDomain = (domain, parentDom) ->
	parentDom.append templates.formPageDomain domain

	domainDom = parentDom.find('.domain').last()

	focusesDom = domainDom.find('.focuses')
	for focus in domain.focuses
		deserializeFocus focus, focusesDom

	domainDom.find('.addFocus').click (event) ->
		event.preventDefault()

		focusesDom = $(event.target).parents('.domain').find('.focuses')
		deserializeFocus DEFAULT_FOCUS, focusesDom
		focusesDom.children().last().find('textarea').first().focus()

deserializeFocus = (focus, parentDom) ->
	parentDom.append templates.formPageFocus focus

	focusDom = parentDom.children('.focus').last()

	[mostRecentRev, pastRevs...] = focus.revisions

	deserializeFocusRevision mostRecentRev, focusDom.children('.mostRecentRevision')

	for rev in pastRevs
		deserializeFocusRevision rev, focusDom.children('.pastRevisions')

deserializeFocusRevision = (focusRev, parentDom) ->
	parentDom.append templates.formPageFocusRev focusRev
	revDom = parentDom.children().last()

	console.log revDom
	revDom.find('textarea').blur (event) ->
		# Remove the focus item if fields are blank and no past revisions
		allEmpty = true
		for textarea in revDom.find('textarea')
			if $(textarea).val()
				allEmpty = false
				break

		if allEmpty
			focusDom = revDom.parents('.focus')

			if focusDom.find('.pastRevisions').children().length is 0
				focusDom.remove()

showNewPatientPage = ->
	$('.page').remove()
	$('body').append templates.newPatientPage()

	$('.page > button.create').click (event) ->
		firstName = $('.page .firstName.field').val()
		lastName = $('.page .lastName.field').val()
		jNumber = $('.page .jNumber.field').val()

		# Show save as dialog
		fileNameSuggestion = "#{lastName}_#{firstName}.careplan"
		dialogDom = $('input.dialog')
		dialogDom.attr 'nwsaveas', fileNameSuggestion

		dialogDom.change (event) ->
			NProgress.start()
			path = this.value

			fs.exists path, (exists) ->
				NProgress.done()

				if exists
					alert 'File already exists!  Either delete the existing file, or choose a new location.'
					return

				carePlan = {
					patient: {firstName, lastName, jNumber}
					domains: ({name, focuses: []} for name in DEFAULT_DOMAIN_NAMES)
				}
				showFormPage carePlan, path

		dialogDom.click()

showFormPage = (carePlan, filePath) ->
	$('.page').remove()
	deserializeCarePlan carePlan, $('body')

$ ->
	compileTemplates()
	showNewPatientPage()
	#showFormPage('somewhere')
