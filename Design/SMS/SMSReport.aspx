<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SMSreport.aspx.cs" Inherits="Design_SMS_SMSreport" MasterPageFile="~/DefaultHome.master" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" >
        $(function () {
            $('#txtFromDate').change(function () {
                ChkDate();

            });

            $('#txtToDate').change(function () {
                ChkDate();

            });

        });


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
        var getresponse = function () {
            serverCall('smsReport.aspx/GetSMSResponse', { smsid: $('#txtsmsresponse').val() }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                });
                return;
            });
        }
    </script>
     <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>SMS Report </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Critaria
            </div>
            
                <div class="col-md-24">
                    <div class="col-md-1"></div>
            <div class="row">       
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:TextBox ID="txtFromDate" runat="server"  ClientIDMode="Static"></asp:TextBox>
                          <cc1:CalendarExtender ID="calFromDate" runat="server"
                            TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ></asp:TextBox>
                         <cc1:CalendarExtender ID="calToDate" runat="server"
                            TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Report Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:DropDownList ID="ddlreporttype" runat="server">
                            <asp:ListItem Value="E">Excel</asp:ListItem>
                            <asp:ListItem Value="PDF">PDF</asp:ListItem>
                        </asp:DropDownList>
                </div>
                </div>
                    <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton"  ClientIDMode="Static" OnClick="btnSearch_Click" />
            
        </div>
         <div class="POuter_Box_Inventory" style="display:none">
            <div class="Purchaseheader">
                Delivery Status
            </div>
             <div class="col-md-24">
                    <div class="col-md-1"></div>
            <div class="row">       
                <div class="col-md-3">
                    <label class="pull-left">SMS Response</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-16">
                       <input type="text" id="txtsmsresponse" placeholder="SMS Response"  />
                </div>
                <div class="col-md-3">
                   <input type="button"  class="ItDoseButton" onclick="getresponse(this)" value="Get Delivery Status"  />
                </div></div>
                  <div class="col-md-1"></div>
             </div>
    </div>
</asp:Content>
