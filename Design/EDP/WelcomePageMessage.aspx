<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="WelcomePageMessage.aspx.cs" Inherits="Design_EDP_WelcomePageMessage" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        function validate() {
            if ($.trim($("#txtMessage").val()) == "")  {
                $("#lblMsg").text('Please Enter Welcome Message ');
                $("#txtMessage").focus();
                return false;
            }

        }
        function Check(textBox, maxLength) {
            if (textBox.value.length > maxLength) {
                $("#<%=lblMsg.ClientID%>").text("You cannot enter more than " + maxLength + " characters.");
                textBox.value = textBox.value.substr(0, maxLength);
            }
        }
    </script>
        <div id="Pbody_box_inventory">
           <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Welcome Message</b><br />
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Complaint
                </div>
                <table style="width: 100%">
                    <tr>
                        <td style="text-align:right; vertical-align:central">
                           Welcome Message :&nbsp;
                            </td>
                        <td>
                            <asp:TextBox ID="txtMessage" onkeyup="javascript:Check(this, 1000);" onchange="javascript:Check(this, 1000);" ClientIDMode="Static" runat="server" TextMode="MultiLine" Width="480px" Height="80px"></asp:TextBox>
                            </td>
                        </tr>
                    <tr>
                        <td style="text-align:right; vertical-align:central">
                           Welcome Description Message :&nbsp;
                            </td>
                        <td>
                            <asp:TextBox ID="txtWelcomeDescription" onkeyup="javascript:Check(this, 1000);" onchange="javascript:Check(this, 1000);" ClientIDMode="Static" runat="server" TextMode="MultiLine" Width="480px" Height="80px"></asp:TextBox>
                            </td>
                        </tr>
                
                    
                    </table>
                <table>
                    <tr><td style="width: 209px; text-align:right"></td><td style="width: 426px"><asp:CheckBox ID="chkActive" runat="server" Text="Current" />&nbsp;</td>
                        <td><asp:Label ID="lblID" runat="server" Visible="false"></asp:Label></td><td></td>
                    </tr>
                </table>
                </div>
             <div class="POuter_Box_Inventory" style="text-align:center">
                 <asp:Button ID="btnSave" ClientIDMode="Static" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" OnClientClick="return validate()" />
                 <asp:Button  ID="btnUpdate" ClientIDMode="Static" runat="server" CssClass="ItDoseButton" Text="Update" OnClick="btnUpdate_Click" OnClientClick="return validate()" Visible="false"/>
                 <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" OnClick="btnCancel_Click" Visible="false" />
                 </div>
<div class="POuter_Box_Inventory" >
            <div class="Purchaseheader" style="height: 19px; ">
                Results</div>
            <table id ="tbNursingprogress" >
                <tr>
                    <td><div style="text-align:center; vertical-align:central;">
                            <asp:GridView ID="grdMessage" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"   OnRowCommand="grdNursing_RowCommand" >
                               
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>

<HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>

<ItemStyle CssClass="GridViewItemStyle" Width="20px"></ItemStyle>
                                    </asp:TemplateField>
                                     <asp:TemplateField HeaderText="Message" ControlStyle-Width="500px">
                            <ItemTemplate>
                                <asp:Label ID="lblMessage" runat="server" Text='<%#Eval("Message") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                                     <asp:TemplateField HeaderText="Message" ControlStyle-Width="500px">
                            <ItemTemplate>
                                <asp:Label ID="lblDiscription" runat="server" Text='<%#Eval("DescriptionMessage") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Current">
                            <ItemTemplate>
                                <asp:Label ID="lblCurrent" runat="server" Text='<%#Eval("Current") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Crated By">
                            <ItemTemplate>
                                <asp:Label ID="lblCreatedBy" runat="server" Text='<%#Eval("CreatedBy") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="Crated Date">
                            <ItemTemplate>
                                <asp:Label ID="lblCreatedDate" runat="server" Text='<%#Eval("CreatedDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                                      <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>'  ImageUrl="~/Images/edit.png" runat="server" />
                              <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                                         
                                </Columns>
                               
                            </asp:GridView>
                            </div>
                       
                    </td>
                </tr>
            </table>
        </div>
             </div>
</asp:Content>

