<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OTBookingTAT.aspx.cs" Inherits="Design_OT_OTBookingTAT" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Common.js"></script>
    <script type="text/javascript" src="../../Scripts/smartCycle.min.js"></script>
    <link href="../../Styles/smartCycleStyle.css" rel="stylesheet" />


    <style type="text/css">
        .abbreviationText {
            font-size: 12px;
            line-height: 14px;
        }

        .abbreviationTextTime {
            font-size: 12px;
            line-height: 14px;
        }

        .sc_object {
            line-height: 1px !important;
            width:80px !important;
            height:80px !important;
        }


        .pointers {
             width:80px !important;
            height:80px !important;
        }

        .sc_center {
            border-radius: 0% !important;
            /*left: 193px !important;*/
            width: 363px !important;
            line-height: 1px !important;
            background-color: white !important;
            color: blueviolet !important;
            /*display:none !important;*/
        }

        .spnCenterDisplayText {
            font-size: 15px;
            line-height: 14px;
            font-weight: bold;
        }

        .completeState {
            background-color: green !important;
        }

        .pendingState {
            background-color: red !important;
        }

        .completeStateArrow {
            color: green !important;
        }

        .completeStateArrowText {
            color: black !important;
            font-size: 14px !important;
        }

        .pendingStateArrow {
            color: red !important;
        }


        body {
            background-color: white;
            /*transform: scale(0.8);*/
            /*transform-origin: 0 0;*/
        }
    </style>
    <script>

        //**************Global Variables***********//

        //var radio = 160;
        //var radio_arrows = 140;
        var radio = 160;
        var radio_arrows = 130;
        //var container_width = 420, container_height = 420;
        //var c_container_width = 420, c_container_height = 420;

        var container_width = 420, container_height = 420;
        var c_container_width = 420, c_container_height = 420;

        var bookingTATStates = [];
        var bookingTATStates_pos = 0;
        var totalBookingTATStates_pos = 0;

        //**************Global Variables***********//


        $(document).ready(function () {
            getBookingTAT(function (data) {
                createBookingTATData(data, function () {
                    createInitialStates(function () {
                        createSmartCycle(function () {
                            initiatAllStates();
                        });
                    });
                });
            });
        });





        var getBookingTAT = function (callback) {
            var bookingID = '<%=ViewState["OTBookingID"].ToString()%>';

            serverCall('OTBookingTAT.aspx/GetBookingTAT', { bookingID: bookingID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }




        var createBookingTATData = function (data, callback) {
            bookingTATStates_pos = Math.floor(data.length / 2);
            for (var i = 0; i < data.length; i++) {
                data[i].stateDisplayString =  '</br>' + '</br>' + data[i].Abbreviation + '</br> <b>' + data[i].DisplayStartTime + '<b>';
                bookingTATStates.push(data[i]);
            }
            totalBookingTATStates_pos = bookingTATStates.length;
            callback(bookingTATStates);
        }



        var createInitialStates = function (callback) {
            var divcontainer = $('.container');
            divcontainer.find('.divCycle').append('<div class="sc_center" style="display:none;"></div>');
            for (var i = 0; i < bookingTATStates_pos; i++) {

                if (bookingTATStates[i].completeStatus > 0)
                    divcontainer.find('.divCycle').append('<div class="sc_object completeState"><span class="abbreviationText">' + bookingTATStates[i].stateDisplayString + '</span></div>');
                else
                    divcontainer.find('.divCycle').append('<div class="sc_object pendingState"><span class="abbreviationText">' + bookingTATStates[i].stateDisplayString + '</span></div>');
            }
            callback();
        }


        var createSmartCycle = function (callback) {
            var divcontainer = $('.container');

            var defaultOption = {
                container_width: container_width,
                container_height: container_height,
                radio: radio,
                radio_arrows: radio_arrows,
                arrows_colors: ['#40A4C0'],
                colors: ['#40A4C0', '#40A4C0']
            }
            divcontainer.find('.divCycle').smartCycle(defaultOption);
            callback();
        }



        var initiatAllStates = function () {
            for (var i = bookingTATStates_pos; i < bookingTATStates.length; i++) {
                createAutoStates();
            }

            var divcontainer = $('.container');
            for (var i = 0; i < bookingTATStates.length; i++) {

                if (bookingTATStates[i].completeStatus > 0)
                    divcontainer.find('.arrow' + (i + 1)).addClass('completeStateArrow');
                else
                    divcontainer.find('.arrow' + (i + 1)).addClass('pendingStateArrow');

            }


            setTimeout(function () {
                divcontainer.find('.sc_center').slideDown('slow');
                var centerDisplayString = '<br/><br/><br/><br/><br/><br/><br/><br/><span class="spnCenterDisplayText">' + bookingTATStates[0].SurgeryName + '</br></br> </span>';
                centerDisplayString += '<span class="spnCenterDisplayText">By ' + bookingTATStates[0].DoctorName + '</br></br>  </span>';
                centerDisplayString += '<span class="spnCenterDisplayText">On ' + bookingTATStates[0].SurgeryDate + '</br></br>  </span>';
                divcontainer.find('.sc_center').html(centerDisplayString);

                var completedStates = $('.pointers.completeStateArrow');
                for (var i = 0; i < completedStates.length; i++) {
                    var completeStatesOuterHTML = completedStates[i].outerHTML;
                    var _completeStatesOuterHTML = $(completeStatesOuterHTML).removeClass('completeStateArrow').addClass('completeStateArrowText').text('15')[0].outerHTML
                   // $(_completeStatesOuterHTML).insertBefore($(completedStates[i]));
                    //console.log(_completeStatesOuterHTML);
                }

                divcontainer.find('.arrow' + bookingTATStates.length).remove();

            }, 1000);

        }

        var createAutoStates = function () {


            var divcontainer = $('.container');

            if (bookingTATStates[bookingTATStates_pos].completeStatus > 0)
                divcontainer.find('.divCycle').append('<div class="sc_object completeState"><span class="abbreviationText">' + bookingTATStates[bookingTATStates_pos].stateDisplayString + '</span></div>');
            else
                divcontainer.find('.divCycle').append('<div class="sc_object pendingState"><span class="abbreviationText">' + bookingTATStates[bookingTATStates_pos].stateDisplayString + '</span></div>');


            //  divcontainer.find('.divCycle').append('<div class="sc_object"><span class="abbreviationText">' + bookingTATStates[bookingTATStates_pos].stateDisplayString + '</span></div>');

            //radio += 25;
            //radio_arrows += 25;
            //container_width += 50;
            //container_height += 50;

            //c_container_width += 50;
            //c_container_height += 50;
            radio += 10;
            radio_arrows += 15;
            //container_width += 30;
            //container_height += 30;

            //c_container_width += 20;
            //c_container_height += 20;

            //container_width += 10;
            //container_height += 10;

            //c_container_width += 5;
            //c_container_height += 5;


            divcontainer.css({
                'width': c_container_width + 'px',
                'height': c_container_height + 'px'
            });

            divcontainer.find('.divCycle').smartCycle('options', {
                'radio': radio, 'radio_arrows': radio_arrows, 'container_width': container_width + 'px',
                'container_height': container_height + 'px',
            });

            divcontainer.find('.divCycle').smartCycle('realign');
            bookingTATStates_pos += 1;

        };
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="container" style="padding-top: 33px;">
                <div class="ciclo1  divCycle">
                </div>
            </div>
        </div>
    </form>
</body>
</html>
