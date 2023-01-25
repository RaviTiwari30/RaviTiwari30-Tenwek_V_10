<%@ Page Language="C#" AutoEventWireup="true" MaintainScrollPositionOnPostback="True"
    MasterPageFile="~/DefaultHome.master" CodeFile="EmployeeVerification_reporting.aspx.cs"
    Inherits="Design_Payroll_EmployeeVerification_reporting" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        $(document).ready(function () {
            $("[id*=chkSelectALLDepartment]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chkDepartment] input").attr("checked", "checked");
                } else {
                    $("[id*=chkDepartment] input").removeAttr("checked");
                }
            });
            $("[id*=chkDepartment] input").bind("click", function () {
                if ($("[id*=chkDepartment] input:checked").length == $("[id*=chkDepartment] input").length) {
                    $("[id*=chkSelectALLDepartment]").attr("checked", "checked");
                } else {
                    $("[id*=chkSelectALLDepartment]").removeAttr("checked");
                }
            });
            $("[id*=cb1]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=Chk1] input").attr("checked", "checked");
                } else {
                    $("[id*=Chk1] input").removeAttr("checked");
                }
            });
            $("[id*=Chk1] input").bind("click", function () {
                if ($("[id*=Chk1] input:checked").length == $("[id*=Chk1] input").length) {
                    $("[id*=cb1]").attr("checked", "checked");
                } else {
                    $("[id*=cb1]").removeAttr("checked");
                }
            });

            $("[id*=rb1] input").bind("click", function () {
                $("input[type='checkbox']").each(function () {
                    this.checked = false;
                });

            });
        });
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Employee Verification Report </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div style="text-align: left;">
                <table>
                    <tr>
                        <td style="width: 8%; height: 3px;" align="left">
                            <asp:RadioButtonList ID="rb1" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Selected="True">Verified</asp:ListItem>
                                <asp:ListItem Value="0">Pending</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td style="width: 10%; height: 3px;" align="right"></td>
                        <td align="center" style="width: 7%; height: 3px;"></td>
                        <td style="width: 9%; height: 3px;"></td>
                        <td style="width: 20%; height: 3px;"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Department
            </div>
            <table>
                <tr>
                    <td align="left" style="width: 8%; height: 3px">
                        <asp:CheckBox ID="chkSelectALLDepartment" runat="server" AutoPostBack="false" Text="Select All"
                            OnCheckedChanged="chkSelectALLDepartment_CheckedChanged" />
                    </td>
                    <td align="right" style="width: 10%; height: 3px"></td>
                    <td align="center" style="width: 7%; height: 3px"></td>
                    <td style="width: 9%; height: 3px"></td>
                    <td style="width: 20%; height: 3px"></td>
                </tr>
                <tr>
                    <td align="left" colspan="5" style="height: 3px">
                        <asp:CheckBoxList ID="chkDepartment" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                        </asp:CheckBoxList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Verification Type
            </div>
            <table>
                <tr>
                    <td style="" colspan="5" align="left">
                        <table style="width: 557px">
                            <tr>
                                <td align="left" style="width: 12%; height: 18px">
                                    <asp:CheckBox ID="cb1" runat="server" AutoPostBack="false" Text="Select All" OnCheckedChanged="cb1_CheckedChanged" />
                                </td>
                                <td align="right" style="width: 10%; height: 18px"></td>
                                <td style="width: 7%; height: 18px" align="right"></td>
                                <td style="width: 14%; height: 18px" align="center">&nbsp;
                                </td>
                                <td style="width: 20%; height: 18px"></td>
                            </tr>
                        </table>
                        <asp:CheckBoxList ID="Chk1" runat="server" Height="16px" RepeatDirection="Horizontal"
                            RepeatColumns="4">
                        </asp:CheckBoxList>
                        &nbsp;&nbsp; &nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="BtnViewByDept" runat="server" Text="Search" ToolTip="Click to Open Report"
                CssClass="ItDoseButton" OnClick="BtnViewByDept_Click" />
        </div>
    </div>
</asp:Content>