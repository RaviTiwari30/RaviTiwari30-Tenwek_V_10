<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="AssetRoomMaster.aspx.cs"
    Inherits="Design_Equipment_Masters_AssetRoomMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">



    
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <asp:ScriptManager ID="smManager" runat="server"></asp:ScriptManager>
                <div style="text-align: center">
                    <b>Room Master<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <div style="text-align: center">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Departments </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="requiredField" ></asp:DropDownList>
                                
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Floor </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:DropDownList ID="ddlFloor" runat="server" CssClass="requiredField"  ></asp:DropDownList>
                                
                        </div>
                        <div class="col-md-3" style="text-align: left">
                            <asp:Button ID="AddFloor" style="Width:75px" OnClick="AddFloor_Click" Text="Add Floor" runat="server" />
                            
                        </div>
                       
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Room Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtname" runat="server" CssClass="requiredField"></asp:TextBox>
                                
                        </div>
                        
                         <div class="col-md-3">
                            <label class="pull-left">Location </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlLocation" runat="server" CssClass="requiredField"  ></asp:DropDownList>
                               
                        </div>
                        <div class="col-md-3" style="text-align: left">
                            <asp:Button ID="AddLocation" style="Width:75px" OnClick="AddLocation_Click" Text="Add Location" runat="server" />
                           
                        </div>
                        
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Description </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkActive" runat="server" Checked="True" Text="Active"/>
                            
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCode" runat="server" Visible="false"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" CssClass="ItDoseButton" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <div class="content" style="overflow: scroll; height: 380px; width: 99%;">
                    <asp:GridView ID="grdRoom" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" OnRowCommand="grdRoom_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Room" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("RoomID")%>' CommandName="EditAT" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Log">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.GIF"
                                        CausesValidation="false" CommandArgument='<%# Eval("RoomID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Department">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("Department") %>
                                    <asp:Label ID="lblDeptID" runat="server" Text='<%#Eval("DepartmentID") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Location">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("LocationName") %>
                                    <asp:Label ID="lbllocationid" runat="server" Text='<%#Eval("LocationID") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Floor">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%#Eval("FloorName") %></ItemTemplate>


                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Name">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate><%#Eval("RoomName") %></ItemTemplate>
                            </asp:TemplateField>

                            <%-- <asp:TemplateField HeaderText="Code">
                            <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <%#Eval("RoomCode") %>
                            </ItemTemplate>
                        </asp:TemplateField>--%>

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

                            <%--<asp:TemplateField HeaderText="IPAddress">
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate><%# Eval("IPAddress") %></ItemTemplate>
                        </asp:TemplateField> --%>
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
                    <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton"
                        Text="Close" />
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