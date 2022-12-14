import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Timer;
import Toybox.Application;
import Toybox.Lang;
import Toybox.Time;


class girracount3View extends WatchUi.View {

    using Toybox.Time.Gregorian;
    using Toybox.Time;
    var times = [["23", "59", "End of Day"]];
    var weekA = true;
    var nextEvent = false;

    public function initialize() {
        View.initialize();
        var t2day = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        switch(t2day.day_of_week) {
            // ATT
            // Events must be in chronological order.

            case "Mon":
                times = [["8", "45", "Assembly"], ["9", "0", "Period 1"], ["10", "0", "Period 2"], ["11", "0", "Recess"], ["11", "20", "Period 3"], ["12", "20", "Period 4"], ["13", "25", "Lunch"], ["14", "05", "Period 5"], ["15", "10", "Day ends"]];
                break;
            
            case "Wed":
                times = [["8", "45", "Period 1"], ["9", "45", "Period 2"], ["10", "45", "Recess"], ["11", "05", "Period 3"], ["12", "10", "Lunch"], ["13", "0", "Period 4"], ["15", "10", "Day ends"]];
                break;
            
            case "Thu":
                times = [["8", "45", "Period 1"], ["9", "50", "Period 2"], ["10", "55", "Recess"], ["11", "15", "Period 3"], ["12", "20", "Period 4"], ["13", "25", "Lunch"], ["14", "05", "Period 5"], ["15", "15", "4U"], ["17", "0", "Day ends"]];
                break;
            
            case "Tue":
            case "Fri":
                times = [["8", "45", "Period 1"], ["9", "50", "Period 2"], ["10", "55", "Recess"], ["11", "15", "Period 3"], ["12", "20", "Period 4"], ["13", "25", "Lunch"], ["14", "05", "Period 5"], ["15", "10", "Day ends"]];
                break;
        }

        var thisDay = t2day.day;
        // Very hacky, works only in september. Hardcoded week numbers
        if ((1 <= thisDay <= 2) || (12 <= thisDay <= 16)) {
            weekA = true;
        } else {
            weekA = false; // therefore is weekB
        }
    }

    function timerCallback() {
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        for (var i = 0; i < times.size(); i += 1) {
            if (today.hour.toNumber() < times[i][0].toNumber()) {
                nextEvent = times[i];
                break;
            } else if (today.hour.toNumber() == times[i][0].toNumber()) {
                if (today.min.toNumber() < times[i][1].toNumber()) {
                    nextEvent = times[i];
                    break;
                }
            }
        }

        if (nextEvent == false) {
            nextEvent = ["23", "59", "End of Day"];
        }

        WatchUi.requestUpdate();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        var timer20s = new Timer.Timer();
        timer20s.start(method(:timerCallback), 20000, true);
        timerCallback();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        if (nextEvent != false) {
            var clockTime = System.getClockTime();
            var tUntil = (nextEvent[0].toNumber() - clockTime.hour) * 60 + (nextEvent[1].toNumber() - clockTime.min);
            var view = View.findDrawableById("tUntil") as Text;
            view.setText(Lang.format("$1$", [tUntil.toString()]));

            view = View.findDrawableById("pName") as Text;
            view.setText(Lang.format("$1$", [nextEvent[2]]));
        }
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
