<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExpenseReport.aspx.cs" Inherits="Design_OPD_ExpenseReport" MasterPageFile="~/DefaultHome.master"%>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript" >
        $(document).ready(function () {
            $('#txtfromDate').change(function () {
                ChkDate();

            });

            $('#txtToDate').change(function () {
                ChkDate();

            });

        });

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });

        }
        $(function () {
            checkAllCentre();
            $("[id*=chkSubGroups]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chlSubGroups] input").attr("checked", "checked");
                } else {
                    $("[id*=chlSubGroups] input").removeAttr("checked");
                }
            });
            $("[id*=chlSubGroups] input").bind("click", function () {
                if ($("[id*=chlSubGroups] input:checked").length == $("[id*=chlSubGroups] input").length) {
                    $("[id*=chlSubGroups]").attr("checked", "checked");
                } else {
                    $("[id*=chkSubGroups]").removeAttr("checked");
                }
            });
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
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Expense Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria</div>            
                  <table   style="width: 100%;border-collapse:collapse">
                       <tr>
                   
                    <td style="width: 20%; text-align:right">
                        Date From :&nbsp;
                    </td>
                  <td style="width: 30%;text-align:left" >

                        <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Select From Date" Width="170px"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="ucFromDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align:right"">
                        Date To :&nbsp;</td>
                    <td style="width: 30%">
                          <asp:TextBox ID="ucToDate" runat="server" ToolTip="Select From Date" Width="170px"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="ucToDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                </tr> 
                    <tr>                   
                       <td style="text-align: right; width: 20%;">
                        Report Type :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                            <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Selected="True" Value="0">PDF</asp:ListItem>
                            <asp:ListItem Value="1">Excel</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>                    
                    <td style="text-align: right; width: 20%">
                    Expense Groups :&nbsp;
                      </td>

                     <td style="text-align: left; width: 35%;">
                     <asp:DropDownList ID="ddlGroups" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlGroups_SelectedIndexChanged"
                            TabIndex="3" ToolTip="Select Item Groups" Width="220px"  >
                        </asp:DropDownList>
                 </td>
                </tr>               
                  <tr>
                      <td  style="text-align:right;width:20%">
                        <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static"  runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" />
                    </td>
                    <td style="text-align:left;"  colspan="3">
                        <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" TabIndex="5" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                    </td>                   
                </tr>                               
            </table>
        </div>
                <div class="POuter_Box_Inventory" >    
                    <div class="Purchaseheader">Expense Type List</div>
                <table   style="width: 100%; text-align:left;">
                    <tr>
                        <td style="text-align: left; width: 10%;border:groove">
                            <asp:CheckBox ID="chkSubGroups" runat="server" Text="SubGroups" AutoPostBack="false"  />
                        </td>
                        <td colspan="4" style="width: 100%;border:groove">
                            <div style="text-align: left;" class="scrollankur">
                                <asp:CheckBoxList ID="chlSubGroups" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" ClientIDMode="Static" 
                                     TabIndex="5">
                                </asp:CheckBoxList>
                            </div>
                        </td>
                    </tr>
                    </table>
               </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnReport" runat="server" OnClick="btnReport_Click" Text="Report"
                ClientIDMode="Static" CssClass="ItDoseButton" TabIndex="3" ToolTip="Click to Open Report" />
        </div>
        </div>
        
    </asp:Content>