<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RateListReport.aspx.cs" Inherits="Reports_Forms_RateListReport"  MasterPageFile="~/DefaultHome.master" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        $("#<%=chkAll.ClientID %>").click(function () {
            $("#<%=chkDepartment.ClientID %>").attr('checked', this.checked);
        });
//        $('#<%=chkDepartment.ClientID %>').click(function () {
//            if ($('#<%=chkDepartment.ClientID %>').length == $('#<%=chkDepartment.ClientID %>:checked').length) {
//                $('#<%=chkAll.ClientID %>').attr("checked", "checked");
//            }
//            else {
//                $('#<%=chkAll.ClientID %>').removeAttr("checked");
//            }
//        });
    });
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center">
                <b>Rate List Report&nbsp;</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <br />
                <asp:RadioButtonList ID="rbtnType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rbtnType_SelectedIndexChanged"
                    RepeatDirection="Horizontal">
                    <asp:ListItem Selected="True">OPD</asp:ListItem>
                    <asp:ListItem>IPD</asp:ListItem>
                    <asp:ListItem>ALL</asp:ListItem>
                </asp:RadioButtonList></div>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%" cellpadding="0" cellspacing="0" class="0">
                <tr>
                    <td style="text-align: right; height: 20px;">
                    </td>
                    <td style="width: 20%; text-align: right;">
                        Panel :&nbsp;
                    </td>
                    <td style="width: 30%; height: 20px;">
                        <asp:DropDownList ID="ddlPanel" runat="server" AutoPostBack="True" 
                            TabIndex="1" Width="300px" OnSelectedIndexChanged="ddlPanel_SelectedIndexChanged">
                        </asp:DropDownList></td>
                    <td style="width: 20%; height: 20px;">
                    </td>
                    <td style="width: 30%; height: 20px;">
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                    </td>
                    <td style="width: 20%; text-align: right;">
                        Category :&nbsp;
                    </td>
                    <td style="width: 30%;">
                        <asp:DropDownList ID="ddlCategory" runat="server" AutoPostBack="True" 
                            TabIndex="2" Width="300px" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged">
                        </asp:DropDownList></td>
                    <td style="width: 20%">
                    </td>
                    <td rowspan="1" style="width: 30%">
                    </td>
                </tr>
                <tr>
                    <td style="height: 16px; text-align: right">
                    </td>
                    <td style="width: 20%; height: 16px; text-align: right">
                        <asp:Label ID="lblSchedule" runat="server" Text="Schedule Charges :&nbsp;"></asp:Label></td>
                    <td style="width: 30%; height: 16px">
                        <asp:DropDownList ID="ddlScheduleCharges" runat="server" 
                             Width="300px" TabIndex="3">
                        </asp:DropDownList></td>
                    <td style="width: 20%; height: 16px">
                    </td>
                    <td rowspan="1" style="width: 30%; height: 16px">
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="width: 20%; text-align: left">
                        Departments :
                        <asp:CheckBox ID="chkAll" Text="Select All" runat="Server" AutoPostBack="false" OnCheckedChanged="chkAll_CheckedChanged" /></td>
                    <td style="width: 80%; text-align: left">
                        <div style="overflow: scroll; height: 150px; width: 850px; text-align: left;" class="border">
                            <asp:CheckBoxList ID="chkDepartment" runat="server" RepeatColumns="2" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="width: 20%; text-align: left">
                        <asp:Label ID="lblCaseType" runat="server" Text="Room Type"></asp:Label>
                         <asp:CheckBox ID="ChkAllRoomType" Text="Select All" runat="Server" AutoPostBack="true" OnCheckedChanged="ChkAllRoomType_CheckedChanged" /></td>
                    <td style="width: 80%; text-align: left">
                        <asp:CheckBoxList ID="chkCaseType" runat="server" RepeatColumns="3" RepeatDirection="Horizontal">
                        </asp:CheckBoxList></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            &nbsp;<asp:Button ID="btnSearch" runat="server" Text="Report" OnClick="btnSearch_Click"
                ValidationGroup="Weekly" CssClass="ItDoseButton" />
        </div>
    </div>
</asp:Content>
