<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TransportTransactionReport.aspx.cs" Inherits="Design_Transport_TransportTransactionReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            bindVehicle();
        });
        function bindVehicle() {
            $.ajax({
                url: "Services/Transport.asmx/bindVehicle1",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        var Vehicle = $.parseJSON(result.d);
                        $("#ddlVehicle").append($("<option></option>").val("0").html("All"));
                        for (var i = 0; i < Vehicle.length; i++) {
                            $("#ddlVehicle").append($("<option></option>").val(Vehicle[i].Id).html(Vehicle[i].Name));
                        }
                    }
                    else {
                        $("#ddlVehicle").append($("<option></option>").val("0").html("--No Data--"));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function ChkDate() {
            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblErrorMsg').text('To date can not be less than from date!');
                        $('#btnExport').attr('disabled', 'disabled');
                        $('#btnPrint').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblErrorMsg').text('');
                        $('#btnExport').removeAttr('disabled');
                        $('#btnPrint').removeAttr('disabled');
                    }
                }
            });
        }

    </script>
     <div class="body_box_inventory">
          <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <div style="height:35px;"></div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <span id="lblHeader" style="font-weight: bold;">Transport Transaction Detail </span>
            <br />
            <span id="lblErrorMsg" class="ItDoseLblError"></span>
        </div>
      
          <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
       

           <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            Category
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21"  style="text-align:left">
                              <asp:RadioButtonList ID="rblTransportDetail" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                            <asp:ListItem Value="0" Text="All" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Department"></asp:ListItem>
                            <asp:ListItem Value="2" Text="patient"></asp:ListItem>
                            <asp:ListItem Value="3" Text="Service"></asp:ListItem>
                            <asp:ListItem Value="4" Text="Maintenance"></asp:ListItem>
                            <asp:ListItem Value="5" Text="Fuel"></asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                          From Date
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                              <asp:TextBox ID="txtFromDate" runat="server" Width="150px" ClientIDMode="static" onchange="ChkDate();"/>
                            <cc1:CalendarExtender ID="clFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        </div>                        
                        <div class="col-md-3">                          
                         To  Date
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left"> 
                              <asp:TextBox ID="txtToDate" runat="server" Width="150px" ClientIDMode="static" onchange="ChkDate();"/>
                            <cc1:CalendarExtender ID="clToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>
                        <div class="col-md-3">                           
                           Vehicle                      
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">                            
                            <select id="ddlVehicle" style="width: 156px;" title="Select Vehicle"></select> 
                        </div>
                    </div>
                     <div class="row">
                       <div class="col-md-3">
                           <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" Checked="true" />
                       </div>
                       <div class="col-md-12">
                           <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                       </div>
                   </div>
                </div>
                <div class="col-md-1"></div>
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-24" style="text-align:center;">                         
                             <input type="button" id="btnView" class="ItDoseButton" onclick="ViewDetails(this)" value="View" />
         <input type="button"id="btnPrint" onclick="ViewDetails(this)"  class="ItDoseButton" value="Print" />
          <asp:CheckBox ID="ChkExport" runat="server" ClientIDMode="Static" Text="Export"/> 
                            <asp:Button ID="btnView1" runat="server" Visible="false" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>      



         </div>
     <div class="POuter_Box_Inventory" style="text-align: center;">
        
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
            <div id="divDetails" style="overflow-x:scroll;width:100%;" >
             </div>
         </div>
         </div>
    <script type="text/javascript">
        function ViewDetails(btn) {
            var ReportType = "";
            $('#lblErrorMsg').html('');
            if ($(btn).val() == 'View') {
                if ($('#ChkExport').is(':checked')) {
                    ReportType = 'Exl';
                }
                else {
                    ReportType = 'View';
                }
            }
            else if ($(btn).val() == 'Print') {
                ReportType = 'pdf';
            }
            var category = 0;
            category = $('#rblTransportDetail input[type="radio"]:checked').val();

            var centreIDs="";

            $('#chkCentre tr').find('input[type=checkbox]:checked').each(function () {
                if (centreIDs == "")
                    centreIDs = $(this).val();
                else
                    centreIDs = centreIDs + "," + $(this).val();
            });

            if (centreIDs == "") {
                $('#lblErrorMsg').text('Please Select Centre');
                return false;
            }
            $.ajax({
                url: 'Services/Transport.asmx/TransportTransactionDetails',
                type: 'POST',
                data: JSON.stringify({ ReportType: ReportType, fromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), Category: category, VehicalId: $('#ddlVehicle').val(), CentreIDs: centreIDs }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                async: false,
                success: function (respons) {
                    if (respons.d != "") {
                        if (respons.d == 'Exl') {
                            window.open('../../Design/common/ExportToExcel.aspx');
                        }
                        else if (respons.d == 'pdf') {
                            window.open('../../Design/common/Commonreport.aspx');
                        }
                        else {
                            Rdata = JSON.parse(respons.d);
                            if (Rdata != null) {
                                var output = $('#spDetails').parseTemplate(Rdata);
                                $('#divDetails').html(output);
                            }
                        }
                    }
                    else {
                        $('#lblErrorMsg').html('Record Not Found');
                        $('#divDetails').html('');
                    }
                }
            });
        }
        $(function () {
            checkAllCentre();
            BindDoctorOrSpeciality();
        });
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

            if (status == true) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }


    </script>
    <script type="text/html" id="spDetails">
        <table style="overflow-x:scroll; width:100%" cellpadding="0" cellspacing="0">
            <thead>
                <tr>
                    <td class="GridViewHeaderStyle">CentreName</td>
                    <td class="GridViewHeaderStyle">Type</td>
                    <td class="GridViewHeaderStyle">Vehicle Name</td>
                    <td class="GridViewHeaderStyle">Driver</td>
                    <td class="GridViewHeaderStyle">Driver Mobile No</td>
                    <td class="GridViewHeaderStyle">Billing Date</td>
                    <td class="GridViewHeaderStyle">Amount</td>
                    <td class="GridViewHeaderStyle">Total KMs/Total Fuel</td>
                  
                </tr>
            </thead>
            <tbody>
                <# 
                var datalength=Rdata.length;
                for(var i=0;i<datalength;i++)
                {
                ObjData= Rdata[i];
                #>
                 <tr>
                     <td class="GridViewAltItemStyle"><#= ObjData.CentreName#></td>
                    <td class="GridViewAltItemStyle"><#= ObjData.Type#></td>
                    <td class="GridViewAltItemStyle"><#= ObjData.VehicleName#></td>
                    <td class="GridViewAltItemStyle"><#= ObjData.Driver#></td>
                    <td class="GridViewAltItemStyle"><#= ObjData.DriverMobileNo#></td>
                    <td class="GridViewAltItemStyle"><#=ObjData.BillingDateTime#></td>
                    <td class="GridViewAltItemStyle"><#=ObjData.Amount#></td> 
                    <td class="GridViewAltItemStyle"><#=ObjData.TotalReading#></td> 
                </tr>
                <#}#>
            </tbody>
        </table>
    </script>
</asp:Content>

