<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SearchMRD.aspx.cs" Inherits="Design_MRD_SearchMRD" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>&nbsp;Patient Search MRD</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMrno" runat="server" MaxLength="25" Width=""></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientName" runat="server" MaxLength="25" Width=""></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Room Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlroomname" Width="" OnSelectedIndexChanged="ddlroomname_SelectedIndexChanged" AutoPostBack="true" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Rack Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlrack" runat="server" OnSelectedIndexChanged="cmbAlmirah_SelectedIndexChanged" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Shelf No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlshelf" Width="" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="3" Text="Search"
                    OnClick="btnSearch_Click" ToolTip="Click to Search" />
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Result
            </div>
            <table id="tbAppointment">
                <tr align="center">
                    <td>
                        <asp:GridView ID="grdMRD" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Patient LastName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPatientLName" runat="server" Text='<%#Eval("PLastName") %>'></asp:Label>
                                        <asp:Label ID="lblTransactionid" runat="server" Text='<%#Eval("TransactionID") %>'
                                            Visible="false"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Patient FirstName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPatientFName" runat="server" Text='<%#Eval("PFirstName") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblMRNo" runat="server" Text='<%#Util.GetString(Eval("PatientID")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Room Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblConfirmdate" runat="server" Text='<%#Eval("Roomname") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Rack Name ">
                                    <ItemTemplate>
                                        <asp:Label ID="lblConfirmdate" runat="server" Text='<%#Eval("rackname") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Shelf No.">
                                    <ItemTemplate>
                                        <asp:Label ID="lblConfirmdate" runat="server" Text='<%#Eval("Shelfno") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Position" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblposition" runat="server" Text='<%#Eval("CurPos") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
