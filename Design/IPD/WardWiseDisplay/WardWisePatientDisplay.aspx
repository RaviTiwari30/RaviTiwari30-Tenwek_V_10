<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WardWisePatientDisplay.aspx.cs" Inherits="Design_IPD_WardWiseDisplay_WardWisePatientDisplay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <link href="Theme/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" />

    <link href="Theme/css/sb-admin.css" rel="stylesheet" />
    <link href="Theme/css/sb-admin.min.css" rel="stylesheet" />
    <style>
        blink {
            color: #2d38be;
            font-size: 25px;
            font-weight: bold;
            cursor: pointer;
        }

        .rerquired {
            border-color: red;
            cursor: pointer;
        }

        i {
            cursor: pointer;
        }

        .blink_text {
            animation: 2s blinker linear infinite;
            -webkit-animation: 1s blinker linear infinite;
            -moz-animation: 1s blinker linear infinite;
            color: red;
        }

        @-moz-keyframes blinker {
            0% {
                opacity: 1.0;
            }

            50% {
                opacity: 0.0;
            }

            100% {
                opacity: 1.0;
            }
        }

        @-webkit-keyframes blinker {
            0% {
                opacity: 1.0;
            }

            50% {
                opacity: 0.0;
            }

            100% {
                opacity: 1.0;
            }
        }

        @keyframes blinker {
            0% {
                opacity: 1.0;
            }

            50% {
                opacity: 0.0;
            }

            100% {
                opacity: 1.0;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div id="content-wrapper">

            <div class="container-fluid">

                <div class="container-fluid">


                    <div class="breadcrumb   mt-3">
                        Ward Wise Patient Display

                    </div>


                    <div class="row">

                        <div class="col-md-12">
                            <!-- DataTables Example -->
                            <div class="card mb-3">
                                <div class="card-header">
                                    <i class="fas fa-bars"></i>
                                    Ward Wise Patient Display Search Criteria
                                </div>
                                <div class="card-body">

                                    <div class="row">
                                        <div class="col-md-2">
                                            Ward :-
                                        </div>
                                        <div class="col-md-4">

                                            <div class="form-group">
                                                <select id="ddlFloor" title="Select Floor" class=" form-control rerquired"></select>

                                            </div>

                                        </div>
                                        <div class="col-md-2">
                                            Ward Type :-
                                        </div>
                                        <div class="col-md-4">

                                            <div class="form-group">
                                                <select id="cmbRoom" title="Select Room Type" class=" form-control rerquired"></select>


                                            </div>

                                        </div>


                                    </div>


                                </div>

                                <div class="card-footer" style="text-align: center">
                                    <input type="button" id="btnSave" class="save margin-top-on-btn btn-primary " value="SEARCH" onclick="GetPatient();" tabindex="35" />

                                </div>
                            </div>
                        </div>

                    </div>
                    <div id="alertHideandShow" class="mt-1" style=" text-align:center ;font-weight: bold;display: none">
                        <div id="mainIdAlert" class="alert alert-danger alert-dismissible">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close" onclick="alertHide()">&times;</a>
                            <span id="alertMessage"></span>
                        </div>
                    </div>

                    <div class="breadcrumb   mt-3 hideandshowresult">
                        Ward Wise Patient Display

                    </div>


                    <div class="row hideandshowresult">

                        <div class="col-md-12">
                            <!-- DataTables Example -->
                            <div class="card mb-3">

                                <div class="card-body">

                                    <div class="row" id="divAppendPatientCard">
                                    </div>



                                </div>


                            </div>
                        </div>

                    </div>



                </div>







            </div>


        </div>




    </form>

    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>

    <script src="Theme/js/Common.js"></script>


    <script type="text/javascript">
        var dataRoom = [];
        var dataFloor = [];

        jQuery(function () {
            $('.hideandshowresult').hide();
            BindFloor();
            bindRoomType();

        });


        function BindFloor() {
            var ddlFloor = jQuery("#ddlFloor");
            jQuery("#ddlFloor option").remove();

            var Floor = {
                type: "POST",
                url: "WardWisePatientDisplay.aspx/BindFloor",
                data: '{ }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    Floor = jQuery.parseJSON(result.d);
                    if (Floor != null) {

                       // ddlFloor.append(jQuery("<option></option>").val("0").html("Select"));
                        if (Floor.length == 0) {
                            ddlFloor.append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {

                            for (i = 0; i < Floor.length; i++) {
                                ddlFloor.append(jQuery("<option></option>").val(Floor[i].ID).html(Floor[i].NAME))
                                dataFloor.push(Floor[i].ID);
                                // if (Floor.length == 1)
                                //ddlFloor.val(Floor[i].ID).attr('disabled', 'disabled');
                            }
                        }
                    }

                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            };
            jQuery.ajax(Floor);
        }

        function bindRoomType() {
            jQuery("#cmbRoom option").remove();
            jQuery.ajax({
                url: "WardWisePatientDisplay.aspx/BindRoomType",
                data: '{FloorID:"' + $('#ddlFloor').val() + '",isAttenderRoom:"' + 0 + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    RoomData = jQuery.parseJSON(result.d);
                    $("#cmbRoom").append($("<option></option>").val("0").html("Select"));
                    if (RoomData != null) {


                        for (i = 0; i < RoomData.length; i++) {
                            $("#cmbRoom").append($("<option></option>").val(RoomData[i].IPDCaseTypeID).html(RoomData[i].Name));
                            dataRoom.push(RoomData[i].IPDCaseTypeID);
                            if (RoomData.length == 1)
                                $("#cmbRoom").val(RoomData[i].IPDCaseTypeID).attr('disabled', 'disabled');
                        }
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function ViewAlert(Message) {
            $("#alertMessage").text(Message);
            $("#alertHideandShow").show();
        }

        function alertHide() {
            $("#alertMessage").text("");
            $("#alertHideandShow").hide();
        }

        function GetPatient() {
            alertHide();
            var floor = $("#ddlFloor ").val();
            var room = $("#cmbRoom ").val();

            if (floor == 0) {

                ViewAlert("Select Floor");
                return false;
            }
            if (room == 0) {
                ViewAlert("Select Room");
                return false;
            }
            serverCall('WardWisePatientDisplay.aspx/GetPatientData', { Floor: floor, Room: room }, function (response) {
                console.log(response)


                var Partientdata = JSON.parse(response);

                if (Partientdata.status) {
                    data = Partientdata.data;
                    $('#divAppendPatientCard').empty();

                    $.each(data, function (i, item) {
                        var cllab = "";
                        var clRad = "";
                        var clPes = "";
                        var clPro = "";
                        if (item.LabCount>0) {
                            cllab="blink_text";
                        }
                        if (item.RadCount > 0) {
                            clRad = "blink_text";
                        }
                        if (item.MedCount > 0) {
                            clPes = "blink_text";
                        }
                        if (item.ProCount > 0) {
                            clPro = "blink_text";
                        }


                        var color = "#ecdcdc";
                        var newDiv = "";
                        newDiv += '<div class="col-6 col-sm-3 mb-3">';
                        newDiv += '<div class="card  null o-hidden h-100" style="border: 2px solid #26c59d; border-radius: 15px; box-shadow: 4px 5px 0px 0px #26c59d" >';
                        newDiv += '<div class="card-body">';
                        newDiv += '<div class="card-body-icon">';
                        //newDiv += '<i class="fas fa-fw fa-calendar"></i>';
                        newDiv += '</div>';
                        newDiv += ' <div class="mr-1"> Name :- ' + item.PatientName + '</div>';
                        //newDiv += ' <div class="mr-1"> Mobile :- ' + item.Mobile + '</div>';
                        newDiv += ' <div class="mr-1"> Age / Gender :-' + item.Age + ' / ' + item.Gender + '</div>';
                        newDiv += ' <div class="mr-1"> IPD No. :- ' + item.IpNo + '</div>';

                        //newDiv += ' <div class="mr-1"> Floor :- ' + item.FLOOR + '</div>';
                        newDiv += ' <div class="mr-1"> Ward :- ' + item.Ward + '</div>';
                        newDiv += ' <div class="mr-1"><i class="fas fa-vial "><blink class=' + cllab + '>(' + item.LabCount + ')</blink></i>&nbsp;&nbsp;<i class="fas fa-x-ray "> <blink  class='+clRad+'>(' + item.RadCount + ') </blink></i>&nbsp;&nbsp;<i class="fas fa-prescription "><blink  class='+clPes+'> (' + item.MedCount + ')</blink></i>&nbsp;&nbsp;<i class="fas fa-notes-medical"> <blink  class='+clPro+'>(' + item.ProCount + ')</blink></i></div>';
                        newDiv += '</div>';
                        newDiv += ' </div>  </div>';


                        $('#divAppendPatientCard').append(newDiv);


                    });

                    if (data.length > 0) {

                        $('.hideandshowresult').show();

                    } else {
                        $('.hideandshowresult').hide();

                        ViewAlert(Partientdata.resMes)

                    }

                } else {
                    ViewAlert(Partientdata.resMes)

                }

            });
        }


    </script>
</body>
</html>
