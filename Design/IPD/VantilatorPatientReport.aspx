<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="VantilatorPatientReport.aspx.cs" Inherits="Design_IPD_VantilatorPatientReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" >
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();

            });

            $('#ucToDate').change(function () {
                ChkDate();

            });

        });


        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }
        function bindVentilator() {
            var isinfected = 0;
            if ($('#chkInfected').is(':checked'))
                var isinfected = 1;
            $.ajax({
                url: "VantilatorPatientReport.aspx/Ventilator",
                data: '{FromDate:"' + $.trim($('#ucFromDate').val()) + '",ToDate:"' + $.trim($('#ucToDate').val()) + '",IPDNo:"' + $.trim($('#txtIPDNo').val()) + '",IsInfected:"' + isinfected + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    Dial = jQuery.parseJSON(response.d);
                    if (Dial != null) {
                        var output = $('#sc_VantilatorSummary').parseTemplate(Dial);
                        $('#SummaryOutput').html(output);
                        $('#SummaryOutput').show();
                    }
                    else {
                        $('#SummaryOutput').hide();
                    }
                }
            });
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpeBookDirectAppointment')) {
                    $find('mpeBookDirectAppointment').hide();
                    $('#spninfection,#spninfectionUser').text('');
                }
            }
        }
        function close() {
            if ($find('mpeBookDirectAppointment')) {
                $find('mpeBookDirectAppointment').hide();
                $('#spninfection,#spninfectionUser').text('');
            }
        }
        function View(rowid) {
            $('#spninfection').text($.trim($(rowid).closest('tr').find("#td10").text()));
            $('#spninfectionUser').text($.trim($(rowid).closest('tr').find("#td8").text()));
            $find('mpeBookDirectAppointment').show();
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
          
                <b>Patient Vantilator Report</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria</div>
            <table style="width: 100%">
                <tr>
                    <td  style="text-align:right;width:20%">
                        From Date :&nbsp;
                    </td>
                    <td  style="width: 30%;text-align:left" colspan="2">
                        <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" Width="170px"
                            TabIndex="1"></asp:TextBox>
                        <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy" ClientIDMode="Static"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="text-align:right;width:20%">
                        To Date :&nbsp;
                    </td>
                    <td style="text-align:left;width:30%">
                        <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Select To Date"  Width="170px"
                             TabIndex="2"></asp:TextBox>
                        <cc1:CalendarExtender ID="Todatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%;">
                       IPD No. :&nbsp;
                    </td>
                    <td style="width: 30%" colspan="2">
                      <input type="text" id="txtIPDNo" style="width:170px" maxlength="10" />  &nbsp;
                    </td>
                    <td style="text-align: right; width: 20%;">
                     
                    </td>
                    <td style="width: 20%;">
                      <input type="checkbox" id="chkInfected"  />Infected Patient
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSearch" class="ItDoseButton" value="Search" onclick="bindVentilator()" />
             <asp:Button  ID="btnSetItem" runat="server" style="display:none"/>
        </div>
    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader">Rearch Result</div>
          <table>
         <tr style="width:100%">
                    <td colspan="5" style="text-align:center">
                        <div id="SummaryOutput" style="max-height: 700px;width:1000px; overflow-x: auto; text-align:center">

                        </div></td></tr>
         </table></div>
    </div>
      <script id="sc_VantilatorSummary" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_VantilatorSummary"
    style="width:960px;border-collapse:collapse; text-align:center">
		<tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none">View</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">IPD No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Age/Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Department</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Date of Insertion</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Date of Removal</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">No. of Days</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">Ward Incharge</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">View</th>
		</tr>
        <#
        var objRow;
        for(var j=0;j<Dial.length;j++)
        {
        objRow = Dial[j];
        #>
                    <tr id="Tr2" >
                    <td class="GridViewLabItemStyle" style="width:10px;display:none;"><img src="../../Images/view.GIF"  style="cursor:pointer" onclick="bindDialysisDetail(this)"/></td>
                    <td class="GridViewLabItemStyle"  id="td1" style="width:10px;"><#=j+1#></td>
                        <td class="GridViewLabItemStyle"  id="td_Dialysis" style="width:10px;"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="td2"  style="width:100px;text-align:center" ><#=objRow.PID#></td>
                    <td class="GridViewLabItemStyle" id="td3"  style="width:60px;text-align:center" ><#=objRow.TID#></td>
                    <td class="GridViewLabItemStyle" id="td4"  style="width:50px;text-align:center;" ><#=objRow.Age#></td>
                    <td class="GridViewLabItemStyle" id="td5"  style="width:100px;text-align:center" ><#=objRow.WardName#></td>
                    <td class="GridViewLabItemStyle" id="td6"  style="width:100px;text-align:center" ><#=objRow.DateofInsertion#></td>
                    <td class="GridViewLabItemStyle" id="td7"  style="width:100px;text-align:center" ><#=objRow.DateofRemoval#></td>
                    <td class="GridViewLabItemStyle" id="td9"  style="width:100px;text-align:center" ><#=objRow.Days#></td>
                    <td class="GridViewLabItemStyle" id="td8"  style="width:100px;text-align:center;display:none" ><#=objRow.InfControlNurse#></td>
                        <td class="GridViewLabItemStyle" id="td10"  style="width:100px;text-align:center;display:none" ><#=objRow.Infection#></td>
                    <td class="GridViewLabItemStyle" id="td11"  style="width:100px;text-align:center" >
                        <img id="imgRmv" src="../../Images/view.GIF" alt="Print" onclick="View(this)"  title="Click To View"/>
                    </td>
                          </tr>
        <#}
        #>
     </table>
    </script>
    <asp:Panel ID="pnPreviousVisit" runat="server" CssClass="pnlItemsFilter" Style="display: none; width: 430px; height: 150px;">
                                <div>
                                    <div class="Purchaseheader" style="text-align: left;">
                                        View Infection Detail&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;
                            <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" alt="Close" style="cursor: pointer" onclick="close()" onkeypress="onKeyDown();" />
                                to close</span></em>
                                    </div>
                                    <table>
                                        <tr>
                                            <td style="text-align:left">
                                         Infection  :&nbsp;
                                            </td>
                                            <td style="text-align:left">
                                                <span id="spninfection"></span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align:left">Infection Control Nurse :&nbsp;</td>
                                            <td style="text-align:left"><span id="spninfectionUser"></span></td>
                                        </tr>
                                    </table>


                                    <div>
                                        <table style="text-align: center">
                                            <caption>   
                                                <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" Style="display: none" Text="Cancel" />
                                            </caption>

                                        </table>
                                    </div>
                                </div>
                                
                            </asp:Panel>
         <cc1:modalpopupextender ID="mpeBookDirectAppointment" runat="server" DropShadow="true"
                                PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel" PopupControlID="pnPreviousVisit"
                                TargetControlID="btnSetItem" BehaviorID="mpeBookDirectAppointment">
                            </cc1:modalpopupextender>
</asp:Content>

