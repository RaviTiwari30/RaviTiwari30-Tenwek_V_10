<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Calender.aspx.cs" Inherits="Design_OPD_Calender"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server" >
<link rel='stylesheet' href="../../Scripts/fullcalendar/fullcalendar.css" />    
    <script type='text/javascript' src='../../Scripts/fullcalendar/fullcalendar.min.js'></script>
    
    <script type="text/javascript">

        $(document).ready(function () {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: '{ DocID: "' + $("#<%=lblDocID.ClientID %>").text() + '"}', 
                url: "Calender.aspx/GetEvents",
                dataType: "json",
                async: false,
                success: function (data) {
                    $('div[id*=fullcal]').fullCalendar({
                        theme: true,
                        showTime: true,
                        //defaultView: 'dayGridMonth',
                        slotEventOverlap: false,
                        handleWindowResize: false,

                        header: {
                            left: 'prev,next today',
                            center: 'title',
                            right: 'month,agendaWeek,agendaDay'
                            //right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
                        },
                        disableDragging: false,
                        selectable: false,
                        selectHelper: true,
                        timeFormat: 'H:mm',
                        slotMinutes: 10,
                        allDaySlot: false,
                        editable: false,
                        overlap: false,

                        minTime: 8,
                        maxTime: '18:10',
                        //fetch time from practitioner details
                        lazyFetching: false,
                        allDaySlot: false,
                        contentHeight: 560,
                        allDayText: 'Volledige dag',
                        // eventTextColor: 'Yellow',
                        eventBackgroundColor: 'green',
                        //  editable: false,
                        textColor: 'black',
                        firstDay: 1,
                        titleFormat: {
                            month: 'MMMM yyyy',
                            week: "MMM d[ yyyy]{ '&#8212;'[ MMM] d yyyy}",
                            day: 'dddd, MMM d, yyyy'

                        },
                        columnFormat: {
                            month: 'dddd',
                            week: 'dddd \n dd/MM',
                            day: 'dddd dd MMM yyyy'
                        },

                        events: $.map(data.d, function (item, i) {
                          
                            var sdate = item.StartDate;

                            var sdatesplit = sdate.split("-");
                            var sm = sdatesplit[0];
                            var sm = sm - 1;
                            var sd = sdatesplit[1];
                            var sy = sdatesplit[2];
                            var syearsplit = sy.split(" ");

                            var edate = item.EndDate;
                            var edatesplit = edate.split("-");
                            var em = edatesplit[0];
                            var em = em - 1;
                            var ed = edatesplit[1];
                            var ey = edatesplit[2];

                            var eyearsplit = ey.split(" ");
                            var stime = item.EventStarttime;

                            var stimesplit = stime.split(":");
                            var etime = item.EventEndtime;
                            var etimesplit = etime.split(":");
                            var event = new Object();
                            event.id = item.EventID;
                            event.start = new Date(syearsplit[0], sm, sd, stimesplit[0], stimesplit[1]);
                            event.end = new Date(eyearsplit[0], em, ed, etimesplit[0], etimesplit[1]);
                            event.title = item.EventName;
                            event.ImageType = item.ImageType;
                            event.tooltip = item.tooltip;
                            event.color = "green";
                            event.allDay = false;
                            return event;
                           
                        }),
                        eventMouseover: function(calEvent,jsEvent) {
                            xOffset = 5;
                            yOffset = 15;
                            $("body").append(calEvent.tooltip);
                            $("#tooltip")
                                .css("top",(jsEvent.clientY - xOffset) + "px")
                                .css("left", (jsEvent.clientX + yOffset) + "px")
                                .css("background-color","#C2E6FF")
                                .fadeIn("fast");
                        },
                        eventMouseout: function(calEvent,jsEvent) {
                            $("#tooltip").remove();	
                        },
                    
                        eventRender: function (event, eventElement) {
                            if (event.ImageType) {
                                if (eventElement.find('span.fc-event-time').length) {
                                    eventElement.find('span.fc-event-time').before($(GetImage(event.ImageType)));
                                }
                                else {
                                    eventElement.find('span.fc-event-title').before($(GetImage(event.ImageType)));
                                }
                            }
                        },

                        loading: function (bool) {
                            if (bool) $('#loading').show();
                            else $('#loading').hide();
                        }

                    });
                },
                onDayLinkClick: function (event) {
                    alert(event.data.Date.toLocaleDateString());
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    debugger;
                }
            });
            $('#loading').hide();
            $('div[id*=fullcal]').show();
        });

        function GetImage(type) {
             if (type == 1) {
                return "<img src = '../../Images/check_16x16.gif' style='width:24px;height:14px'/>"
            }
           
        }
    </script>
    <div id="loading">
        <img src="../../images/loadingAnim.gif" alt="" />
       
    </div>
    <div>Doctor Schedule</div>
    <div id="fullcal"  style="margin-top:17px">
    </div>
     <asp:Label ID="lblDocID" runat="server" Style="display:none"></asp:Label>

</asp:Content>
