<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="DisplayExaminationToken.aspx.cs" Inherits="DisplayExaminationToken" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title></title>
 
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>
    <link href="../../Styles/jquery-ui.css" rel="stylesheet" />
    <style type="text/css">
        table {
        font-weight:bold;
        font-size:40px;
        }
        body {
        background-color:lightyellow;
        }
    </style>
    <script type="text/javascript">

        $(document).ready(function () {

            GetDisplayToken();
            bindPendingToken();

            var refreshId = setInterval(function () {
                GetDisplayToken();
                bindPendingToken();
            }, 5000);
        });

        //function GetNightTime() {
        //    $.ajax({
        //        url: 'DisplayExaminationToken.aspx/GetTime',
        //        data: '{}',
        //        dataType: "json",
        //        contentType: "application/json;charset=UTF-8",
        //        async: false,
        //        type: "POST",
        //    }).done(function (r) {

        //    });
        //}

        function GetDisplayToken() {
            $.ajax({
                url: 'DisplayExaminationToken.aspx/BindDisplayToken',
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (data) {
                var objdata = $.parseJSON(data.d);
                if (data.d != '') {
                    $('#tbody').html("");
                    var token;
                    var name;
                    var counter;
                    $("#tbodyCurrent").empty();
                    for (var i = 0; i < objdata.Table.length - 1; i++) {
                        var value = objdata.Table[i];
                        for (var m = 0; m < value.length; m++) {
                            if (m == 0) {
                                token = value[0];
                            }
                            else if (m == 1) {
                                name = value[2];
                            }
                            else if (m == 2) {
                                counter = value[1];
                            }
                        }

                        $("#tbodyCurrent").append("<tr id='trData' style='background-color:#c5fdc5;'><td style='text-align:left;width:25%;background-color:#efc77d;'>" + counter + "</td><td style='text-align:left;width:55%;'>" + name + "</td><td style='text-align:center;width:20%;'>" + token + "</td></tr>");
                        
                    }
                    //$.each(objdata, function (i, v) {

                    //    num++;
                    //});
                    // 
                }
            });
        }


        function bindPendingToken() {
            serverCall('DisplayExaminationToken.aspx/bindPendingToken', {}, function (response) {
                responseData = JSON.parse(response);
                $("#tbodyPending").empty();
                if (responseData != '') {
                    for (var i = 0; i < responseData.length; i++) {
                        if(responseData[i].IsAbsent==0)
                            $("#tbodyPending").append("<tr id='trData'><td style='text-align:left;width:25%;'>Waiting</td><td style='text-align:left;width:55%;'>" + responseData[i].PatientName + "</td><td style='text-align:center;width:20%;'>" + responseData[i].ExaminationTokenNo + "</td></tr>");
                        else
                            $("#tbodyPending").append("<tr id='trData' style='background-color:yellow;'><td style='text-align:left;width:25%;'>Waiting</td><td style='text-align:left;width:55%;'>" + responseData[i].PatientName + "</td><td style='text-align:center;width:20%;'>" + responseData[i].ExaminationTokenNo + "</td></tr>");
                    }
                }

           });



        }

        //window.setTimeout(function () {
        //    setTimeout(arguments.callee, 100);
        //}, 100);
        //jQuery(function ($) {
        //    var h = window.innerHeight;
        //    $('[id$=divR]').on('scroll', function () {
        //        if ($(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight) {
        //            $('[id$=divR]').scrollTop(0)
        //        }
        //    })
        //});
        //window.setInterval(function () {
        //    //alert("OK");
        //    GetDisplayToken();

        //}, 5000);
    </script>

    <style type="text/css">
        #tblDisply tr td {
            border: 1px solid lightgray;
        }
    </style>
</head>
<body>



    <div>
        <div>
            <div style="text-align: center; font-weight: bold; font-size: 50px;background-color:#dde0f7; ">
               PRE-EXAMINATION TOKEN DISPLAY SCREEN
            </div>
            <br />
            <div class="row" id="divR">
                <div class="col-md-24" style="height: 830px;">
                    <table style="width: 100%; border: 1px solid lightgray;" id="tblDisply">
                        <thead>
                            <tr style="background-color: #145b8a; color: white;">
                                 <th style="width: 25%;text-align:left;">COUNTER NO.
                                </th>
                                <th style="width: 55%;text-align:left">PATIENT NAME
                                </th>
                                <th style="width: 20%;text-align:center;">TOKEN NO.
                                </th>
                               
                            </tr>
                        </thead>
                        <tbody id="tbodyCurrent"></tbody>
                    </table>
                    <marquee id="marqueeData" direction="up" height="650px" behaviour="slide" scrollamount="2">
                     <table style="width:100%;border:1px solid lightgray;" id="tblDisplayPending">
                        <tbody id="tbodyPending"></tbody>
                    </table>
                           </marquee>
                </div>
                <div>
                       <div class="col-md-8">
                            <button type="button" style="width:50px;height:50px;margin-left:5px;float:left;background-color:#c5fdc5;border-radius:25px;"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left;font-size:30px;">Current Call</b>
                        </div>
                <div class="col-md-8">
                            <button type="button" style="width:50px;height:50px;margin-left:5px;float:left;background-color:yellow;border-radius:25px;" class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left; font-size:30px;">Absent</b>
                        </div>
                </div>
            </div>

        </div>
    </div>
</body>
</html>


