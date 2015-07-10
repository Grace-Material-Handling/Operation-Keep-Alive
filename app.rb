# app.rb

# login to nutshell
$nutshell = NutshellCrm::Client.new($username, $apiKey)


# limit tasks that will be created
company_task_limit = 5


# this function takes a person as
# an input and checks to see if
# they need to be contacted based
# on their lastContactedDate
def is_stale(person, days = 30)
	# get the persons last contacted date
	date = person["lastContactedDate"]
	# check if person needs to be contacted
	if date.nil?
		true
	else
		date = Date.strptime(date, "%Y-%m-%dT%H:%M:%S")
		date < (Date.today - days)
	end
end


# dates
today = Time.now
next_wedsday = Date.today
next_wedsday += 1 + ((3-next_wedsday.wday) % 7)
next_wedsday = next_wedsday.to_time


# this is an array of our
# staff that will be assigned
# to keep intouch with stale
# companies
staff = [{
	# Christian Juth
	id: 13,
	entityType: "Users",
	meetingTime: next_wedsday + 13.hours
}]


# this query will search for all
# primary contacts in Nutshell
query = {
	tag: ["Primary Contact"]
}


# THIS IS A HACK
# Nutshell limits queries to 100
# results so this will loop through
# and get each page of 100 result
# until the page returns empty
results = []
i = 0
loop do
  i += 1
  responce = $nutshell.find_contacts(query, nil, nil, 100, i, false)
  if responce.length > 0
  	results.concat(responce)
  else
  	break
  end
end


# pass results into the is_stale
# function to filter which people
# need to be contacted
stale_contacts = []
results.each do |contact|
 	if is_stale(contact)
 		stale_contacts.push(contact)
 	end
end


# assign a contact activity to
# a staff member with a stale contacts
loop_index = 1
stale_contacts.each do |contact|

	# limit tasks to be created
	break if loop_index > company_task_limit

	# get a company employe who will
	# paticipate in the activity
	staff_member = staff.sample

	# increment task limit
	loop_index += 1

	# schdual task
	$nutshell.new_task({
		title: "Schdual Meeting",
	    description: "This task was created automatically to keep relations with this person/company from going stale.",
	    "dueTime": staff_member[:meetingTime] += 10.minutes,
	    "assignee": staff.sample,
	    "entity": {
			id: contact["id"],
			entityType: contact["entityType"]
		}
	})
end