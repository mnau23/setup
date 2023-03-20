// Use in Google Apps Script
// NB: as you run it for the first time, you have to approve access to your Google Calendar

function deleteEvents() {
  // usually equal to your Google email
  var calendarID = "<EMAIL>";

  // NB: months are represented from 0-11
  var fromDate = new Date(2020, 0, 1, 0, 0, 0);
  var toDate = new Date(2020, 0, 31, 23, 59, 59);

  var calendar = CalendarApp.getCalendarById(calendarID);

  // also, you could add a search criteria: third parameter as {search: 'EVENT_NAME'}
  var events = calendar.getEvents(fromDate, toDate);

  for (var i = 0; i < events.length; i++) {
    var ev = events[i];

    // log event name and title
    Logger.log("Event: " + ev.getTitle() + " found on " + ev.getStartTime());

    // delete event
    ev.deleteEvent();
  }
}
