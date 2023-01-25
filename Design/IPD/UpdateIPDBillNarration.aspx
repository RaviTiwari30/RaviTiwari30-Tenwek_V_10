<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="UpdateIPDBillNarration.aspx.cs" Inherits="Design_IPD_UpdateIPDBillNarration" %>

<%@Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function closeDetail() {
            if ($find("mpDetail")) {
                $find("mpDetail").hide();
                $("#<%=txtNarration.ClientID %>").val('');
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Change IPD Bill Narration</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        IPD No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtTransactionId" runat="server" AutoCompleteType="Disabled" TabIndex="1" ToolTip="Enter IPD No." MaxLength="15"></asp:TextBox>
                    <%--<cc1:FilteredTextBoxExtender ID="ftbeipd" runat="server" TargetControlID="txtTransactionId">
                    </cc1:FilteredTextBoxExtender>--%>
                </div>

                <div style="text-align: center;" class="col-md-2">
                    <asp:Button ID="btnView" runat="server" OnClick="btnSearch_Click" CssClass="ItDoseButton" ClientIDMode="Static" TabIndex="2" Text="Search" ToolTip="Click To View Patient Details" />
                </div>
            </div>
        </div>
           <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Patient Details 
            </div>
            <div style="overflow: auto; padding: 3px; width: 1290px; height: 274px;">
                <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" Width="1280px" OnSelectedIndexChanged="grdPatientDetail_SelectedIndexChanged"
                    CssClass="GridViewStyle">
                    <Columns>
                        <asp:BoundField DataField="PatientID" HeaderText="UHID">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="IPD No.">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblTransactionID" Visible="false" Text='<%#Util.GetString(Eval("TransactionID")) %>' runat="server"></asp:Label>
                                <asp:Label ID="Label1" Text='<%#Util.GetString(Eval("IPDNo")) %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Name">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblPName" Text='<%# Eval("PName") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                         <asp:BoundField DataField="Mobile" HeaderText="ContactNo">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Address" HeaderText="Address">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                         <asp:BoundField DataField="Company_Name" HeaderText="Panel">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                         <asp:BoundField DataField="BillNo" HeaderText="Bill No">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                         <asp:TemplateField HeaderText="Narration" Visible="false">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblNarration" Text='<%# Eval("Narration") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                          <asp:CommandField HeaderText="Select" ButtonType="Image" ShowSelectButton="true"
                            SelectImageUrl="~/Images/Post.gif">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:CommandField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
        </div>
    </div>
     <cc1:ModalPopupExtender ID="mpDetail" runat="server" CancelControlID="btnClose"
        TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlDetail"
        X="380" Y="200" BehaviorID="mpDetail">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
      <asp:Panel ID="pnlDetail" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none; width: 400px">
            <div class="Purchaseheader">

            Update Bill  Narration
            <em><span style="font-size: 7.5pt;float:right" class="shat">Press click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" alt="" onclick="closeDetail()" />
                to close</span></em>
 
        </div>
           <table style="width: 100%; border-collapse: collapse">
               <tr>
                   <td style="vertical-align: top; text-align: right; width: 5%">Narration :&nbsp;
                </td>
                <td align="left" style="width: 20%" valign="middle">
                   <%-- <textarea id="txtNarration" runat="server" clientidmode="Static" style="height:64px;width:280px;"></textarea>--%>
                    <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine" Width="280px" MaxLength="200"
                                Height="100px"></asp:TextBox>
                   </td>
               </tr>

               </table>
           <div class="filterOpDiv">
            <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="ItDoseButton" OnClick="btnUpdate_Click"
                ToolTip="Click to Update"  />
            &nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnClose" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" ToolTip="Click to Cancel" />&nbsp;
        </div>
          </asp:Panel>
</asp:Content>


