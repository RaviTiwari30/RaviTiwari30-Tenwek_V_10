<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="RoomLog.aspx.cs" Inherits="Design_EDP_RoomLog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="Pbody_box_inventory">
       
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>&nbsp;Room Master</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />

        </div>
     
        <asp:Panel  runat="server" ID="pnlRoomType">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Room Details Log&nbsp;
                </div>
                 <div class="POuter_Box_Inventory" style="text-align: center">
                      <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Room Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlCaseType" ClientIDMode="Static" runat="server" TabIndex="1" ToolTip="Select Room Type"
                               AutoPostBack="True"
                                OnSelectedIndexChanged="ddlCaseType_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                       
                         <div class="col-md-3">
                            <label class="pull-left">
                              Floor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="cmbFloor" runat="server" ToolTip="Select Floor" 
                               AutoPostBack="True"  TabIndex="4" OnSelectedIndexChanged="cmbFloor_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                    </div>
                               
                </div>
                <div class="col-md-1"></div>
            </div>
                 </div>
                <asp:GridView ID="grdInv" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    PageSize="5" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Room Type">
                            <ItemTemplate>
                                <%#Eval("RoomType")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Room Name">
                            <ItemTemplate>
                                <%#Eval("NAME")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Room No.">
                            <ItemTemplate>
                                <%#Eval("Room_No")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bed No.">
                            <ItemTemplate>
                                <%#Eval("Bed_No")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Floor">
                            <ItemTemplate>
                                <%#Eval("Floor")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <%#Eval("Description")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <%#Eval("IsActive")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                       <asp:TemplateField HeaderText="Updated By">
                            <ItemTemplate>
                                <%#Eval("updatername")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Updated On">
                            <ItemTemplate>
                                <%#Eval("Updater_Date")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                       
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
    </div>
</asp:Content>

