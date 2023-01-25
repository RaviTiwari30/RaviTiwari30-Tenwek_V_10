<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EquipmentLocation.aspx.cs" Inherits="Design_Equipment_Masters_EquipmentLocation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" />
</head>
<body style="margin-top: 1px; margin-left: 1px;">
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <asp:ScriptManager ID="smManager" runat="server">
                </asp:ScriptManager>
                <div class="content" style="text-align: center">
                    <b>Equipment Location<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div>

                    <table class="ItDoseLabel" style="text-align: left;">
                        <tr>
                            <td colspan="6">
                                <div class="showheader">Asset Detail</div>
                            </td>
                        </tr>
                        <tr>
                            <td>Asset</td>
                            <td>
                                <asp:DropDownList ID="ddlasset" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlasset_SelectedIndexChanged" Width="204px">
                                </asp:DropDownList>
                            </td>
                            <td>Serial No</td>
                            <td>
                                <asp:TextBox ID="txtserial" runat="server" ReadOnly="True" Width="200px" ForeColor="Black"></asp:TextBox>
                            </td>
                            <td>Supplier</td>
                            <td>
                                <asp:TextBox ID="txtsupplier" runat="server" ReadOnly="True" Width="200px" ForeColor="Black"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6">
                                <div class="showheader">Policy Detail</div>
                            </td>
                        </tr>

                        <tr>
                            <td>Policy Number</td>
                            <td>
                                <asp:TextBox ID="txtpolicyno" runat="server" ReadOnly="True" Width="200px" ForeColor="Black"></asp:TextBox>
                            </td>
                            <td>Provider</td>
                            <td>
                                <asp:TextBox ID="txtprovider" runat="server" ReadOnly="True" Width="200px" ForeColor="Black"></asp:TextBox>
                            </td>
                            <td>Sumed Insuration</td>
                            <td>
                                <asp:TextBox ID="txtpolicyamt" runat="server" ReadOnly="True" Width="200px" ForeColor="Black"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Policy Start Date</td>
                            <td>
                                <asp:TextBox ID="ucformins" runat="server" Width="200px" ForeColor="Black"></asp:TextBox>
                            </td>
                            <td>Policy End Date</td>
                            <td>
                                <asp:TextBox ID="uninsto" runat="server" Width="200px" ForeColor="Black"></asp:TextBox>
                            </td>
                            <td>Duration</td>
                            <td>
                                <asp:TextBox ID="txtpolicydur" runat="server" ReadOnly="True" Width="200px" ForeColor="Black"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6">
                                <div class="showheader">Location Details</div>
                            </td>
                        </tr>
                        <tr>
                            <td>Asset Type:</td>
                            <td>
                                <asp:DropDownList ID="ddlassettype" Width="204px" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlassettype_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                            <td>Warranty From</td>
                            <td>
                                <%--<uc1:entrydate id="ucwarfrom" runat="server" />--%>
                                <asp:TextBox ID="ucwarfrom" runat="server" Width="200px"></asp:TextBox>
                                <cc1:CalendarExtender ID="cal1" runat="server" TargetControlID="ucwarfrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </td>
                            <td>Warranty To</td>
                            <td>
                                <%--<uc1:entrydate id="ucwarto" runat="server" />--%>
                                <asp:TextBox ID="ucwarto" runat="server" Width="200px"></asp:TextBox>
                                <cc1:CalendarExtender ID="cal2" runat="server" TargetControlID="ucwarto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td>Asset Sub Type</td>
                            <td>
                                <asp:DropDownList ID="ddlassetsubtype" runat="server" Width="204px">
                                </asp:DropDownList>
                            </td>
                            <td>Free Service From</td>
                            <td>
                                <%--<uc1:entrydate id="ucfreefrom" runat="server" />--%>
                                <asp:TextBox ID="ucfreefrom" runat="server" Width="200px"></asp:TextBox>
                                <cc1:CalendarExtender ID="cal3" runat="server" TargetControlID="ucfreefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </td>
                            <td>Free Service To</td>
                            <td>
                                <%--<uc1:entrydate id="ucfreeto" runat="server" />--%>
                                <asp:TextBox ID="ucfreeto" runat="server" Width="200px"></asp:TextBox>
                                <cc1:CalendarExtender ID="cal4" runat="server" TargetControlID="ucfreeto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td>Product Description</td>
                            <td>
                                <asp:TextBox ID="txtdes" runat="server" TextMode="MultiLine" Width="200px"></asp:TextBox>
                            </td>
                            <td>Upload Attachment</td>
                            <td>
                                <asp:FileUpload ID="FileUpload1" runat="server" />
                            </td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>Location</td>
                            <td>
                                <asp:DropDownList ID="ddlloc" Width="204px" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlloc_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                            <td>Floor</td>
                            <td>
                                <asp:DropDownList ID="ddlfloor" Width="204px" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlfloor_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                            <td>Room</td>
                            <td>
                                <asp:DropDownList ID="ddlroom" runat="server" Width="204px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Department</td>
                            <td>
                                <asp:DropDownList ID="ddldept" runat="server" Width="204px">
                                </asp:DropDownList>
                            </td>
                            <td>Installation Date</td>
                            <td>
                                <%--<uc1:entrydate id="ucinsdate" runat="server" />--%>

                                <asp:TextBox ID="ucinsdate" runat="server" Width="200px"></asp:TextBox>
                                <cc1:CalendarExtender ID="cal5" runat="server" TargetControlID="ucinsdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="auto-style1">Life Time</td>
                            <td class="auto-style1">
                                <asp:TextBox ID="txtlife" runat="server" Width="200px"></asp:TextBox>
                            </td>
                            <td class="auto-style1"></td>
                            <td class="auto-style1"></td>
                            <td class="auto-style1"></td>
                            <td class="auto-style1"></td>
                        </tr>
                        <tr>
                            <td>Status</td>
                            <td>
                                <asp:CheckBox ID="chk" runat="server" Text="Active" Checked="True" />
                            </td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="auto-style2">&nbsp;</td>
                            <td class="auto-style1">&nbsp;</td>
                            <td class="auto-style6">&nbsp;</td>
                            <td class="auto-style3">&nbsp;</td>
                            <td class="auto-style5">&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="6" style="text-align: center;">


                                <table border="1" style="text-align: left; width: 70%;">
                                    <td colspan="2">
                                        <div class="showheader">Accessory</div>
                                    </td>
                                    <tr>
                                        <td class="auto-style1">Select Accessory </td>
                                        <td>
                                            <asp:DropDownList ID="ddlacc" runat="server" Width="204px">
                                            </asp:DropDownList>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td class="auto-style1">Quantity</td>
                                        <td>
                                            <asp:TextBox ID="txtqty" runat="server" Width="200px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="auto-style1" colspan="2">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="text-align: center;">
                                            <asp:Button ID="btnadd" runat="server" Text="Add Accessory" CssClass="ItDoseButton" OnClick="btnadd_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="text-align: center;">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="text-align: center;">

                                            <asp:GridView ID="gridacc" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                                EnableModelValidation="True" OnRowCommand="gridacc_RowCommand">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Accessory Code">
                                                        <ItemStyle CssClass="GridViewItemStyle" Width="180px" />
                                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lbid" Visible="false" Text='<%#Eval("AccId") %>'></asp:Label>
                                                            <%#Eval("AccCode") %>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Accessory Name">
                                                        <ItemStyle CssClass="GridViewItemStyle" />
                                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                        <ItemTemplate>
                                                            <%#Eval("AccName") %>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Quantity">
                                                        <ItemStyle CssClass="GridViewItemStyle" />
                                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lbdes" Visible="false" Text='<%#Eval("Qty") %>' />
                                                            <%#Eval("Qty") %>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Remove">
                                                        <ItemStyle CssClass="GridViewItemStyle" />
                                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                        <ItemTemplate>
                                                            <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                                                CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>


                                        </td>
                                    </tr>
                                </table>


                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center">
                <table>

                    <tr>
                        <td style="text-align: center;" colspan="2">
                            <asp:Button ID="btnsave" runat="server" OnClick="btnsave_Click" Text="Save" CssClass="ItDoseButton" />
                            <asp:Button ID="btnclear" runat="server" OnClick="btnclear_Click" Text="Clear" CssClass="ItDoseButton" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="showheader">List</div>
                <div class="content" style="overflow: scroll; height: 200px; width: 95%;">

                    <asp:GridView ID="grddetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        EnableModelValidation="True" OnRowCommand="grddetail_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Asset" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("ID")%>' CommandName="EditData" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Log">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.gif"
                                        CausesValidation="false" CommandArgument='<%# Eval("ID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Asset Name">
                                <ItemStyle CssClass="GridViewItemStyle" Width="180px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>

                                    <%#Eval("itemname") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Asset Type">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate>
                                    <%#Eval("assettypename") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Asset SubType">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate>

                                    <%#Eval("assetsubtypename") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Location">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("locationname") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Floor">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("floorname") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Room">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("roomname") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("status") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>


                </div>
            </div>
            <asp:Panel ID="pnlLog" runat="server" Style="width: 600px; border: outset; background-color: #EAF3FD; display: none;">
                <div id="Div1" class="Purchaseheader" style="text-align: center">
                    Log Detail
                </div>
                <div style="overflow: scroll; height: 250px; width: 595px; text-align: left; border: groove;">
                    <asp:Label ID="lblLog" runat="server"></asp:Label>
                </div>
                <div style="text-align: center;">
                    <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton" Text="Close" />
                </div>
            </asp:Panel>
            <cc1:ModalPopupExtender ID="mdpLog" runat="server" CancelControlID="btnClose" TargetControlID="btnHidden"
                BackgroundCssClass="filterPupupBackground" PopupControlID="pnlLog" X="100" Y="80">
            </cc1:ModalPopupExtender>
            <div style="display: none;">
                <asp:Button ID="btnHidden" runat="server" Text="Button" />
            </div>
        </div>
    </form>
</body>
</html>
