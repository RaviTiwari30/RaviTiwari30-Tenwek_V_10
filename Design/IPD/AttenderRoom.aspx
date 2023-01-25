<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AttenderRoom.aspx.cs" Inherits="Design_IPD_AttenderRoom" ClientIDMode="Static" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="~/Design/Controls/StartDateTime.ascx" TagName="StartDate" TagPrefix="uc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartDate" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript">
        function validate(btn) {
            if ($.trim($("#txtName").val()) == "") {
                $("#txtName").focus();
                $("#lblMsg").text('Please Enter Attended Name');
                return false;
            }
            if ($("#ddlRelationship").val() == "0") {
                $("#ddlRelationship").focus();
                $("#lblMsg").text('Please Select Relationship');
                return false;
            }

            if ((($("#ddlAvailRooms").val() == "0") || ($("#ddlAvailRooms option:selected").text() == "")) && ($("#btnSave").val() == "Save")) {
                $("#ddlAvailRooms").focus();
                $("#lblMsg").text('Please Select Available Room');
                return false;
            }
            btn.disabled = true;
            btn.value = "Submitting.....";
            __doPostBack('btnSave');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>Patient Attender Room Billing</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Attended Room Billing
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: right">Room Category :&nbsp;
                        </td>

                        <td style="text-align: left">
                            <asp:RadioButtonList ID="rblRoomCategory" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" RepeatLayout="Table" AutoPostBack="true" OnSelectedIndexChanged="rblRoomCategory_SelectedIndexChanged">
                               <asp:ListItem Text="Attender Room" Value ="1" ></asp:ListItem>
                                 <asp:ListItem Text="Actual Room" Value ="0" Selected="True"></asp:ListItem>
                                 
                            </asp:RadioButtonList>
                            </td>
                        <td style="text-align: right">&nbsp;</td>
                        <td style="text-align: left">
                            &nbsp;</td>
                        <td align="left">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align: right">Attender Name :&nbsp;
                        </td>

                        <td style="text-align: left">
                            <asp:TextBox ID="txtName" MaxLength="100" runat="server" Width="244px"></asp:TextBox>
                            <span style="color: red; font-size: 10px;" class="shat">*</span>
                        </td>
                        <td style="text-align: right">Relationship :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlRelationship" runat="server" Width="250px"></asp:DropDownList>
                            <span class="shat" style="color: red; font-size: 10px;">*</span></td>
                        <td align="left">&nbsp;&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">Room Type :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlRoomType" runat="server" OnSelectedIndexChanged="ddlRoomType_SelectedIndexChanged"
                                AutoPostBack="True" Width="250px" />
                        </td>
                        <td style="text-align: right">Billing Type :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlBillCategory" runat="server" Width="250px" />
                        </td>
                        <td align="left">&nbsp;&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">Available Room :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlAvailRooms" runat="server" Width="250px" />
                            <span class="shat" style="color: red; font-size: 10px;">*</span></td>
                        <td style="text-align: right">
                            <asp:Label ID="lblDateTime" runat="server"  Text="Entry "></asp:Label>Date Time :&nbsp;
                            
                        </td>
                        <td style="text-align: left">
                            <uc1:StartDate ID="txtDate" runat="server" />
                        </td>
                        <td align="left"></td>
                    </tr>
                </table>

            </div>

            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" runat="server"  CssClass="ItDoseButton" OnClick="btnSave_Click" ClientIDMode="Static" Text="Save" OnClientClick="return validate(this)" />
                &nbsp;&nbsp;
                 <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" OnClick="btnCancel_Click" Text="Cancel" Visible="false" />
                &nbsp;&nbsp; &nbsp;&nbsp;
                <span style="background-color: #99FFCC">Status In</span>&nbsp;&nbsp;<span style="background-color: #FF99CC">Status Out</span>
            </div>


            <asp:Panel ID="pnlAttender" Visible="false" runat="server">

                <div class="POuter_Box_Inventory" style="text-align: center">
                    <div class="Purchaseheader">
                        Attended Room Details
                    </div>

                    <asp:GridView ID="grdRoomDetail" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                        OnRowDataBound="grdRoomDetail_RowDataBound" Width="950px" OnRowCommand="grdRoomDetail_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Attended Name" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblAttendedName" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                     <asp:Label ID="lblAttenderType" runat="server" Text='<%# Eval("attenderType") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="RoomType" HeaderText="Room Type" HeaderStyle-Width="90px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="Room" HeaderText="Room" HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="BillingCategory" HeaderText="Billing Category" HeaderStyle-Width="130px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                Visible="false" />
                            <asp:TemplateField HeaderText="Entry Date" HeaderStyle-Width="170px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblEntryDate" runat="server" Text='<%# Eval("EntryDate") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="EntryBy" HeaderText="Entry By" HeaderStyle-Width="140px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="LeaveDate" HeaderText="Out Date" HeaderStyle-Width="170px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:BoundField DataField="OutBy" HeaderText="Out By" HeaderStyle-Width="140px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />

                            <asp:TemplateField HeaderText="Status" HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                                    <asp:Label ID="lblAttendentID" runat="server" Text='<%# Eval("attendentID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblRelationship" runat="server" Text='<%# Eval("Relationship") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                <ItemTemplate>

                                    <asp:Button ID="btnOut" runat="server" CssClass="ItDoseButton" Text="Out"
                                        CausesValidation="false" CommandArgument='<%# Eval("attendentID")+"#"+Eval("RoomID") %>'
                                        CommandName="Out" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>


                <asp:Label ID="lblPanelID" runat="server" Visible="False"></asp:Label>
                <asp:Label ID="lblPatientID" runat="server" Visible="False"></asp:Label>
                <asp:Label ID="lblTransactionNo" runat="server" Visible="False"></asp:Label>
                <asp:Label ID="lblAttendedID" runat="server" Visible="False"></asp:Label>
                <asp:Label ID="lblEnterydate" runat="server" Visible="False"></asp:Label>
            </asp:Panel>
        </div>

    </form>
</body>
</html>
