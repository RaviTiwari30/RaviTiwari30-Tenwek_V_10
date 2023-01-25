<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OPD_BillRegister.aspx.cs" Inherits="Design_OPD_BillRegister" MasterPageFile="~/DefaultHome.master"  %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
     <script type="text/javascript" >
         $(document).ready(function () {
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
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%=chkCentre.ClientID %>  input[type=checkbox]').length)) {
               $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
           }
           else {
               $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
           }
        }
         function checkAllPanel() {
             if ($('#<%= chkPanel.ClientID %>').is(':checked')) {
                   $('.chkAllPanelCheck input[type=checkbox]').attr("checked", "checked");
               }
               else {
                   $(".chkAllPanelCheck input[type=checkbox]").attr("checked", false);
               }
         }
         function chkPanelCon() {
             if (($('#<%= chkAllPanel.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkAllPanel.ClientID %>  input[type=checkbox]').length)) {
                  $('#<%= chkPanel.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkPanel.ClientID %>').attr("checked", false);
            }
        }
    </script>
    <div id="Pbody_box_inventory">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
                <b>OPD Bill Register Report</b><br />
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                       <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal" Height="16px">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Group Wise</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <asp:RadioButtonList ID="rdbgroupwise" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="B" Selected="True">Bill Wise</asp:ListItem>
                                <asp:ListItem Value="C">Category Wise</asp:ListItem>
                                <asp:ListItem Value="S">Sub Category</asp:ListItem>
                                <asp:ListItem Value="I">Item Wise</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                        <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="rbtnReportType" runat="server" RepeatDirection="Horizontal">
                             <asp:ListItem Text="All" Value="-1" Selected="True"></asp:ListItem>
                       <%--     <asp:ListItem Text="OPD" Value="1" ></asp:ListItem>
                                 <asp:ListItem Text="Shift To IPD" Value="2"></asp:ListItem>--%>
                                  <asp:ListItem Text="OPD OutStanding" Value="3"></asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                             <div class="col-md-3">
                            <label class="pull-left">UHID</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtUHID" runat="server" AutoCompleteType="Disabled"></asp:TextBox> 
                        </div>
                              <div class="col-md-3">
                            <label class="pull-left">Bill No.</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtBillNo" runat="server" AutoCompleteType="Disabled"></asp:TextBox> 
                        </div>
                    </div>
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">
                                 From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Select From Date"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="ucFromDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="ucToDate" runat="server" ToolTip="Select From Date"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="ucToDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                        </div>
                       
                    </div>
                    <div class="row">
                        
                       
                        <div class="col-md-3" >
                            <asp:CheckBox ID="chkPanel" ClientIDMode="Static" runat="server" onclick="checkAllPanel();" Text="Panel" />
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="height:250px;width:1000px;overflow-y:scroll">
                           <asp:CheckBoxList ID="chkAllPanel" onclick="chkPanelCon()" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" CssClass="chkAllPanelCheck ItDoseCheckboxlist" RepeatLayout="Table" RepeatColumns="10"></asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            &nbsp;<asp:Button ID="btnSearch" ClientIDMode="Static" runat="server" Text="Report" OnClick="btnSearch_Click" ValidationGroup="Weekly" CssClass="ItDoseButton" /></div>
    </div>

</asp:Content>
