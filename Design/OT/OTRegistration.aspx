<%@ Page  Language="C#" AutoEventWireup="true" CodeFile="OTRegistration.aspx.cs" Inherits="Design_OT_OTRegistration" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <style type="text/css">
        
    </style>




    <title>Untitled Page</title>

    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../../Styles/chosen.css" />
    <link rel="stylesheet" href="../../Styles/grid24.css" />
    <link rel="stylesheet" href="../../Styles/CustomStyle.css" />
    <link rel="Stylesheet" href="../../Styles/MarcTooltips.css" />
    <link rel="Stylesheet" href="../../Styles/Newcss/opa-icons.css" />
    <script type="text/javascript">

        $(document).ready(function () {
            $('select').chosen();
            $('#txtdiagnosis,#txtweight').bind('paste', function (e) {
                e.preventDefault();
            });


            $('#btnsave').bind('click', function (e) {
                e.preventDefault();


                var surgeryID = $.trim($('#ddlSurgery').val());
                var surgeonID = $.trim($('#ddlSurgeon').val());
                var otSchedule = $.trim($('#txtOTTiming').val());

                if (surgeryID == '0') {
                    modelAlert('Please Select Surgery.');
                    return false;
                }

                if (surgeonID == '0') {
                    modelAlert('Please Select Surgeon.');
                    return false;
                }

                if (otSchedule == '') {
                    modelAlert('Please Select Schedule.');
                    return false;
                }

                document.getElementById('btnsave').disabled = true;
                document.getElementById('btnsave').value = 'Submitting...';
                __doPostBack('btnsave', '');

            })


        });









        var $selectSlot = function (elem) {

            var status = $(elem).hasClass("badge-pink");
            var alreadySeletedOT = 0;
            var selectedSlots = $('#divSlotAvailabilityBody').find('.badge-pink');
            if (selectedSlots.length > 0) {
                alreadySeletedOT = Number($(selectedSlots[0]).closest("div[class*='_slotParent']").attr('OT'));
                var selectedOT = Number($(elem).closest("div[class*='_slotParent']").attr('OT'));
                if (alreadySeletedOT != selectedOT) {
                    modelAlert('Signle OT Room  at a time.');
                    return false;
                }
            }

            if (status)
                $(elem).removeClass('badge-pink');
            else
                $(elem).addClass('badge-pink');



            selectedSlots = $('#divSlotAvailabilityBody .badge-pink');

            if (selectedSlots.length > 0) {
                var startTime = $(selectedSlots[0]).find('#spnSlotTime').text().split('-')[0];
                var endTime = $(selectedSlots[selectedSlots.length - 1]).find('#spnSlotTime').text().split('-')[1];


                var firstSelected = Number($(selectedSlots[0]).attr('id'));
                var lastSelected = Number($(selectedSlots[selectedSlots.length - 1]).attr('id'));

                for (var i = firstSelected + 1; i < lastSelected; i++) {
                    $(selectedSlots[0]).closest("div[class*='_slotParent']").find('#' + i).addClass('badge-pink');
                }
            }

        }


        var onOTScheduling = function () {

            var alreadyBookDate = $.trim($('#txtScheduleDate').val());

            if (alreadyBookDate != '')
                $('#txtSchedulingDate').val(alreadyBookDate);

            var date = $('#txtSchedulingDate').val();
            getOTSchedule({ fromDate: date, day: 0 });
        }


        var onPrevOTScheduling = function () {
            var date = $('#txtSchedulingDate').val();
            getOTSchedule({ fromDate: date, day: -1 });
        }

        var onNextOTScheduling = function () {
            var date = $('#txtSchedulingDate').val();
            getOTSchedule({ fromDate: date, day: 1 });
        }


        var getOTSchedule = function (data) {
            serverCall('../../Design/OT/Services/Scheduling.asmx/GetOTSchedule', data, function (response) {
                var responseData = JSON.parse(response);

                $('#txtSchedulingDate').val(responseData.date);


                var htmlStr = '';
                for (var i = 1; i < responseData.data.length; i++) {
                    htmlStr = htmlStr + '<div OT=' + i + ' style="padding-left: 0px;" class="' + i + '_slotParent ' + (i < responseData.data.length - 1 ? 'col-md-5' : 'col-md-4') + '">' + responseData.data[i] + '</div>';
                }

                $('#divSlotAvailability').find('#divSlotAvailabilityBody').html(htmlStr);
                bindSelectedTime();
                $('#divSlotAvailability').showModel();
                MarcTooltips.add('.badge-purple', 'Already Booked!', {
                    position: 'up',
                    align: 'left'
                });
            });
        }


        var selectSchedule = function (elem) {
            var selectedSlots = $('#divSlotAvailabilityBody .badge-pink');
            if (selectedSlots.length > 0) {
                var startTime = $(selectedSlots[0]).find('#spnSlotTime').text().split('-')[0];
                var endTime = $(selectedSlots[selectedSlots.length - 1]).find('#spnSlotTime').text().split('-')[1];
                var scheduleDate = $('#txtSchedulingDate').val();
                $('#txtOTTiming').val('On ' + scheduleDate + ' From ' + startTime + ' To ' + endTime);
                $('#txtScheduleDate').val(scheduleDate);
                $('#txtScheduleFromTime').val(startTime);
                $('#txtScheduleToTime').val(endTime);
                $('#txtOTNumber').val(Number($(selectedSlots[0]).closest("div[class*='_slotParent']").attr('OT')));
                $('#divSlotAvailability').closeModel();
            }
        }





        var bindSelectedTime = function () {
            var OT = Number($('#txtOTNumber').val());
            var alreadyBookDate = $.trim($('#txtScheduleDate').val());
            var s = $.trim($('#txtSchedulingDate').val());

            if (alreadyBookDate.toLowerCase() != s.toLowerCase())
                return false;


            $('.' + OT + '_slotParent').find('.square').each(function () {

                var timing = $(this).find('#spnSlotTime').text();
                var startTime = $.trim(timing.split('-')[0]);
                var endTime = $.trim(timing.split('-')[1]);

                var fromTime = $.trim($('#txtScheduleFromTime').val());
                var toTime = $.trim($('#txtScheduleToTime').val());
                if (fromTime == startTime)
                    $(this).click();

                if (endTime == toTime)
                    $(this).click();

            });
        }




    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" >
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Patient OT Registration & Schedule</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Patient Details
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Select Surgery
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:DropDownList CssClass="requiredField" runat="server" ID="ddlSurgery"></asp:DropDownList>
                            </div>
                            <div class="col-md-5"></div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Surgeon 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList CssClass="requiredField" runat="server" ID="ddlSurgeon"></asp:DropDownList>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Anaesthetist
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlDoctor" runat="server" TabIndex="5">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Assistant
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlassistant" runat="server" TabIndex="5"></asp:DropDownList>
                            </div>
                            <div style="padding-left: 0px;display:none" class="col-md-1">
                                <asp:Button ID="btnNewAssistant" runat="server" CssClass="pull-left" Text="New" ToolTip="Click To Add New Assistant" />
                               
                            </div>

                        </div>


                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    PAC Required
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList runat="server" ID="rbtlistpac">
                                    <asp:ListItem Text="Yes"></asp:ListItem>
                                    <asp:ListItem Text="No"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Weight (KG)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtweight" onlynumber="5" decimalplace="2" max-value="150" CssClass="ItDoseTextinputNum" runat="server" MaxLength="6"></asp:TextBox>

                            </div>


                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    OT Timing 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:TextBox runat="server" disabled="true" ID="txtOTTiming"></asp:TextBox>
                                <asp:TextBox runat="server" Style="display: none" ID="txtScheduleDate"></asp:TextBox>
                                <asp:TextBox runat="server" Style="display: none" ID="txtScheduleFromTime"></asp:TextBox>
                                <asp:TextBox runat="server" Style="display: none" ID="txtScheduleToTime"></asp:TextBox>
                                <asp:TextBox runat="server" Style="display: none" ID="txtOTNumber"></asp:TextBox>
                            </div>
                            <div class="col-md-2">
                                <input type="button" class="pull-left" onclick="onOTScheduling()" value="Availability" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Diagnosis
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:TextBox ID="txtdiagnosis" Style="max-height: 49px; min-height: 49px;" runat="server" AutoCompleteType="Disabled" TextMode="MultiLine" ClientIDMode="Static" MaxLength="40"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                             <div class="col-md-3">
                                <label class="pull-left">
                                    Status
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div style="text-align: left;"  class="col-md-20">
                                <asp:Label ID="lblStatus" Font-Bold="true"  Style="" runat="server" AutoCompleteType="Disabled" TextMode="MultiLine" ClientIDMode="Static" MaxLength="40"></asp:Label>
                            </div>


                        </div>

                    </div>
                    <div class="col-md-1"></div>
                </div>
                <table style="width: 99%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: left">
                            <asp:Panel ID="pnlNewAss" runat="server" CssClass="pnlItemsFilter" Style="display: none" Height="110px" Width="320px">
                                <div class="Purchaseheader">
                                    Create Anaesthetist Assistant
                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <asp:Label ID="lblAssError" runat="server" Text="" ForeColor="Red"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-8">
                                        <label class="pull-left">
                                            Assistant
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-16">
                                        <asp:TextBox ID="txtAss" CssClass="requiredField" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div style="text-align: right;" class="col-md-24">
                                        <asp:Button ID="btnAnaAss" runat="server" TabIndex="26" CssClass="save" Text="Save" OnClick="btnAnaAss_Click" />
                                        <asp:Button ID="btnAssCancel" runat="server" TabIndex="26" CssClass="save" Text="Cancel" />
                                    </div>
                                </div>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
                <br />
            </div>
            <div class="POuter_Box_Inventory textCenter">
                <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" OnClientClick="return onSubmitting()" CssClass="save margin-top-on-btn" />
            </div>
        </div>



        <div id="divSlotAvailability" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divSlotAvailability" aria-hidden="true">×</button>

                        <b class="modal-title">OT Date :</b>
                        <asp:TextBox runat="server" onchange="onOTScheduling()" Style="width: 172px" ID="txtSchedulingDate"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="calendarExteTxtSchedulingDate" Format="dd-MMM-yyyy" TargetControlID="txtSchedulingDate"></cc1:CalendarExtender>
                        <button style="box-shadow: none;" onclick="onPrevOTScheduling()" type="button">Prev</button>
                        <button style="box-shadow: none;" onclick="onNextOTScheduling()" type="button">Next</button>
                        <%--<span class="icon icon-color icon-triangle-w"></span>--%>
                    </div>
                    <div class="modal-body">
                        <div>
                            <div class="row">
                                <div style="" class="col-md-5 textCenter ">
                                    <b class="">OT-1 </b>

                                </div>
                                <div style="" class="col-md-5 textCenter">
                                    <b style="padding-right: 19px">OT-2 </b>
                                </div>
                                <div style="" class="col-md-5 textCenter">
                                    <b style="padding-right: 40px">OT-3 </b>
                                </div>
                                <div style="" class="col-md-5 textCenter ">
                                    <b style="padding-right: 65px">OT-4 </b>
                                </div>
                                <div style="" class="col-md-4 textCenter">
                                    <b style="padding-right: 42px">OT-5 </b>
                                </div>
                            </div>
                            <div id="divSlotAvailabilityBody" style="padding-left: 30px; width: 1020px; height: 370px; overflow: auto" class="row">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-avilable"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Avilable</b>
                        <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-yellow"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Booked</b>
                        <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-purple"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Approved</b>
                        <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-pink"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Selected</b>
                        <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-grey"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Expired</b>
                        <%--   <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-info"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Rejected</b>--%>


                        <button onclick="selectSchedule(this)" type="button">Select</button>
                        <button type="button" data-dismiss="divSlotAvailability">Close</button>

                    </div>
                </div>
            </div>
        </div>


            <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
    </form>






</body>
</html>
