<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="MessageMaster.aspx.cs" Inherits="Design_common_MessageMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center;">
          
                    <b>Message Master </b><br />
               
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
                
           
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader" >
                Results</div>
            <table id="tbMessage" width="100%">
                <tr>
                   
                      
                        <td>
                            <asp:GridView ID="grdMessage" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                Width="100%"   OnRowCancelingEdit="grdMessage_RowCancelingEdit"
                                OnRowEditing="grdMessage_RowEditing" OnRowUpdating="grdMessage_RowUpdating" ShowFooter="True"
                                CellPadding="4" GridLines="None">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="ID" HeaderStyle-HorizontalAlign="Left">
                                        <EditItemTemplate>
                                            <asp:Label ID="lblId" runat="server" Text='<%# Bind("Id") %>'></asp:Label>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="lblId" runat="server" Visible="false" Text='<%# Bind("Id") %>'></asp:Label>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="MSGCODE" HeaderStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMSGCODE" runat="server" Text='<%#Eval("MSGCODE")%>' />
                                        </ItemTemplate>
                                        
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Message" HeaderStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMessage" runat="server" Text='<%#Eval("Message")%>' />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtMessage" Width="200px" runat="server" Text='<%#Eval("Message")%>' />
                                        </EditItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Edit" ShowHeader="False" HeaderStyle-Width="120px"
                                        HeaderStyle-HorizontalAlign="Left">
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="lbkUpdate" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update"></asp:LinkButton>
                                            <asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel"></asp:LinkButton>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit"></asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            </td>
                       
                    
                </tr>
           
            <tr style="text-align:center">
                
                    
                        <td>
                            <asp:Button ID="btnGenerateFunction" CssClass="ItDoseButton" runat="server" Text="Generate Function" OnClick="btnGenerateFunction_Click" />
                        </td>
                    
            </tr>
        </table>
            </div>
    </div>
</asp:Content>
