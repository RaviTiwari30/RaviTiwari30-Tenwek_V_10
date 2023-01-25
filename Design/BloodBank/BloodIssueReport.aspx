<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BloodIssueReport.aspx.cs" Inherits="Design_BloodBank_BloodIssueReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
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
                       $(document).ready(function () {
                           $('#txtIssuedatefrom').change(function () {
                               ChkDate();
                           });
                           $('#txtIssuedateTo').change(function () {
                               ChkDate();
                           });
                       });
                       function ChkDate() {
                           $.ajax({
                               url: "../common/CommonService.asmx/CompareDate",
                               data: '{DateFrom:"' + $('#txtIssuedatefrom').val() + '",DateTo:"' + $('#txtIssuedateTo').val() + '"}',
                               type: "POST",
                               async: true,
                               dataType: "json",
                               contentType: "application/json; charset=utf-8",
                               success: function (mydata) {
                                   var data = mydata.d;
                                   if (data == false) {
                                       $('#<%=lblerrmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnPrint.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblerrmsg.ClientID %>').text('');

                        $('#<%=btnPrint.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Blood Issue/Return Report</b><br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Component Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlComponentName" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbType" runat="server" TabIndex="4" RepeatDirection="Horizontal">
                                <asp:ListItem Text="OPD" Value="OPD"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                                <asp:ListItem Text="EMG" Value="EMG"></asp:ListItem>
                                <asp:ListItem Selected="True" Value="ALL">ALL</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdoReport" runat="server" TabIndex="4" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Text="ISSUE" Value="1"></asp:ListItem>
                                <asp:ListItem Text="RETURN" Value="2"></asp:ListItem>
                                <asp:ListItem Text="ALL" Value="3"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Issue From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIssuedatefrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldatefrom" TargetControlID="txtIssuedatefrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Issue To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIssuedateTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldateTo" TargetControlID="txtIssuedateTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre " />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal" Height="16px">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="btnPrint" Text="Report" CssClass="ItDoseButton" runat="server" OnClick="btnPrint_Click" />
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
