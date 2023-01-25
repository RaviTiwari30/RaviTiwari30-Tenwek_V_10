<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="FloorMaster.aspx.cs" Inherits="Design_Equipment_Masters_FloorMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" >
                <asp:ScriptManager ID="smManager" runat="server"></asp:ScriptManager>
                <div class="row">
                <div class="col-md-19" style="text-align: center">
                    <b>Floor Master</b>
                </div>
                    <div class="col-md-5" style="text-align: right">
                     <asp:HyperLink ID="hyperlink1" NavigateUrl="AssetRoomMaster.aspx"  Text=" Back On Room Master Screen  " runat="server" />
                        </div>
                    </div>
                <div style="text-align: center;">
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div style="text-align: center">
                    <div class="row">
                                            <div class="col-md-3">
                            <label class="pull-left">
                               Floor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                            <asp:TextBox ID="txtname" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                               
                        </div>
                    <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                Location
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5" style="display:none">
                            <asp:DropDownList ID="ddlLocation" runat="server" CssClass="ItDoseDropdownbox" Visible="False"></asp:DropDownList>
                               
                        </div>

                    

                        <div class="col-md-3">
                            <label class="pull-left">
                               Description
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-5">
                           <asp:TextBox ID="txtDescription" runat="server" Width="302px" CssClass="ItDoseTextinputText"></asp:TextBox>
                               
                        </div>
                        <div class="col-md-5">
                                                   <asp:CheckBox ID="chkActive" runat="server" Checked="True" Text="Active" CssClass="ItDoseCheckbox" />

                               
                        </div>
                        <div class="col-md-5" style="display:none">
                        <asp:TextBox ID="txtCode" runat="server" Width="100px" Visible="false" CssClass="ItDoseTextinputText"></asp:TextBox>

                               
                        </div>
                        </div>








            
                </div>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center; ">
                <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" CssClass="ItDoseButton" />            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; ">
                <div class="content" style="overflow: scroll; height: 405px; width: 99%;">
                    <asp:GridView ID="grdFloor" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" OnRowCommand="grdFloor_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Floor" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("FloorID")%>' CommandName="EditData" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Log">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.GIF"
                                        CausesValidation="false" CommandArgument='<%# Eval("FloorID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%-- <asp:TemplateField HeaderText="Location">
                            <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate><%#Eval("LocationName") %></ItemTemplate>
                        </asp:TemplateField>--%>

                            <asp:TemplateField HeaderText="Name">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate><%#Eval("FloorName") %></ItemTemplate>
                            </asp:TemplateField>
                            <%--
                        <asp:TemplateField HeaderText="Code">
                            <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <%#Eval("FloorCode") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                            --%>
                            <asp:TemplateField HeaderText="Desc">
                                <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("Description") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Active">
                                <ItemStyle CssClass="GridViewItemStyle" Width="40px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%#Eval("IsActive") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="User">
                                <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%# Eval("LastUpdatedby") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Date/Time">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%# Eval("UpdateDate") %></ItemTemplate>
                            </asp:TemplateField>

                            <%--     <asp:TemplateField HeaderText="IPAddress">
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate><%# Eval("IPAddress") %></ItemTemplate>
                        </asp:TemplateField>--%>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <asp:Panel ID="pnlLog" runat="server" Style="width: 500px; border: outset; background-color: #EAF3FD; display: none;">
                <div id="Div1" class="Purchaseheader" style="text-align: center">Log Detail </div>
                <div style="overflow: scroll; height: 250px; width: 495px; text-align: left; border: groove;">
                    <asp:Label ID="lblLog" runat="server"></asp:Label>
                </div>
                <div style="text-align: center;">
                    <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton" Text="Close" />
                </div>
            </asp:Panel>
            <cc1:ModalPopupExtender ID="mdpLog" runat="server" CancelControlID="btnClose"
                TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlLog"
                X="100" Y="80">
            </cc1:ModalPopupExtender>
            <div style="display: none;">
                <asp:Button ID="btnHidden" runat="server" Text="Button" />
            </div>
        </div>
  

    </asp:Content>