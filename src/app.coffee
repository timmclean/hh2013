TEMPLATE_NAMES = [
	'formPage',
	'formPageDomain',
	'formPageFocus',
	'formPageFocusRev',
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
		focusesDom = $(event.target).parents('.domain').find('.focuses')
		deserializeFocus DEFAULT_FOCUS, focusesDom
		focusesDom.children().last().find('textarea').first().focus()

deserializeFocus = (focus, parentDom) ->
	parentDom.append templates.formPageFocus focus

	focusDom = parentDom.children('.focus').last()

	[mostRecentRev, pastRevs...] = focus.revisions

	focusDom.children('.mostRecentRevision').html templates.formPageFocusRev mostRecentRev

	for rev in pastRevs
		deserializeFocusRevision rev, focusDom.children('.pastRevisions')

deserializeFocusRevision = (focusRev, parentDom) ->
	parentDom.append templates.formPageFocusRev focusRev

showFormPage = (filePath) ->
	carePlan = {
		patient: {
			name: "Amy Pond"
			jNumber: "J 10998123"
		}
		domains: ({name, focuses: []} for name in DEFAULT_DOMAIN_NAMES)
	}
	carePlan.domains[0].focuses = [
		{
			revisions: [
				timestamp: ''
				description: 'Major Depressive Disorder\nLikely OCD\nSocial Anxiety'
				solution: 'Health teaching re: depression and coping strategies for depression and anxiety given and printed material provided.\nExposure is the best treatment and avoidance makes things worse'
				initials: ''
			]
		}
		{
			revisions: [
				timestamp: ''
				description: 'Suicidal ideation with plan'
				solution: 'Review "Dealing with Distress booklet" to identify alternative strategies to cope with chronic suicidal thoughts.\nComposed a Safety Plan, agrees to review regularly and utilize steps outlined should you fall into crisis.  Suicidal intention and planning has completely resolved at the time of discharge'
				initials: ''
			]
		}
	]
	carePlan.domains[2].focuses = [
		{
			revisions: [
				timestamp: ''
				description: 'Current medication'
				solution: 'clomipramine 100 mg at bedtime\nLoxapine 10 mg at bedtime.\nativan 2 mg at bedtime (recommend minimize use; taper and discontinue)'
				initials: ''
			]
		}
	]

	deserializeCarePlan carePlan, $('.page')

$ ->
	compileTemplates()
	showFormPage('somewhere')
