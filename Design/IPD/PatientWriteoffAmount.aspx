<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientWriteoffAmount.aspx.cs" Inherits="Design_IPD_PatientWriteoffAmount" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
          <cc1:ToolkitScriptManager runat="server" ID="scrScriptmanager"></cc1:ToolkitScriptManager>
    
      <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>Patient Write Off Amount</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                </div>
            </div>
             <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Bill Amount</label>
                        <b class="pull-right">:</b></div>
                  
                <div class="col-md-4">
                    <asp:Label ID="lblTotalBillAmount" runat="server"  CssClass="ItDoseLabelSp"></asp:Label>
                    </div>
                 <div class="col-md-4">
                        <label class="pull-left">Disount Amount</label>
                        <b class="pull-right">:</b></div>
                
                <div class="col-md-4">
                    <asp:Label ID="lblDiscountAmount" runat="server"></asp:Label>
                    </div>
          <div class="col-md-4">
                        <label class="pull-left">Net Amount</label>
                        <b class="pull-right">:</b></div>
                  
                <div class="col-md-4">
                    <asp:Label ID="lblNetAmount" runat="server"></asp:Label>
                    <asp:Label ID="lblPanelID" runat="server" Visible="false"></asp:Label>
                    </div>
          </div>
                 <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">Allocation Amount</label>
                        <b class="pull-right">:</b></div>
                  
                <div class="col-md-4">
                    <asp:Label ID="lblAllocationAmount" runat="server"></asp:Label>
                    </div>
                 <div class="col-md-4">
                        <label class="pull-left">Patient Advance</label>
                        <b class="pull-right">:</b></div>
                
                <div class="col-md-4">
                    <asp:Label ID="lblAdvanceAmount" runat="server"></asp:Label>
                    </div>
          <div class="col-md-4">
                        <label class="pull-left">Already Writeoff</label>
                        <b class="pull-right">:</b></div>
                  
                <div class="col-md-4">
                    <asp:Label ID="lblAlreadyOff" runat="server"></asp:Label>
                    </div>
          </div>
                 <div class="row">
                      <div class="col-md-4">
                         <label class="pull-left">Balance</label>
                          <b class="pull-right">:</b></div>
                    
                     <div class="col-md-4">
                              <asp:Label ID="lblBalance" runat="server"  ></asp:Label>
                    
                     </div>
                     <div class="col-md-4">
                         <label class="pull-left">WriteOff</label>
                          <b class="pull-right">:</b></div>
                    
                     <div class="col-md-2">
                              <asp:TextBox ID="txtWriteOff" runat="server" CssClass="requiredField" ></asp:TextBox>
                     <cc1:FilteredTextBoxExtender ID="ftbx" runat ="server" TargetControlID ="txtWriteOff" ValidChars =".0123456789"></cc1:FilteredTextBoxExtender>
                     </div>
                       <div class="col-md-2">
                           </div>
                     <div class="col-md-4">
                           <label class="pull-left">Reason</label>
                          <b class="pull-right">:</b>
                     </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtReason" runat="server"  CssClass="requiredField" TextMode="MultiLine"></asp:TextBox>
                     </div>
                      </div>
         </div>
           <div class="POuter_Box_Inventory textCenter">

                
               <asp:Button  ID="btnSave" runat="server" CssClass="ItdoseButton" Text="Save" OnClick="btnSave_Click"/>
               
               <asp:Button  ID="btnUpdate" runat="server" CssClass="ItdoseButton" Text="Update" Visible="false" OnClick="btnUpdate_Click"/>
               </div>
           <div class="POuter_Box_Inventory">
            <asp:GridView ID="grdWriteOffDetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdWriteOffDetail_RowCommand" OnRowDataBound="grdWriteOffDetail_RowDataBound" TabIndex="6" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="WriteOff Amount">
                            <ItemTemplate>
                                <asp:Label ID="lblWriteOffAmount" runat="server" Text='<%#Eval("WriteOffAmount") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        
                         <asp:TemplateField HeaderText="WriteOff Reason">
                            <ItemTemplate>
                                <asp:Label ID="lblWriteOffReason" runat="server" Text='<%#Eval("WriteOffReason") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Verified By">
                            <ItemTemplate>
                                <asp:Label ID="lblVerifiedBy" runat="server" Text='<%#Eval("VerifiedBy1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="VerifiedOn">
                            <ItemTemplate>
                                <asp:Label ID="lblVerifiedOn" runat="server" Text='<%#Eval("VerifiedOn1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="EntryDateTime">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDateTime" runat="server" Text='<%#Eval("EntryDateTime1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="EntryBy">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("EntryBy1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>

 <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CausesValidation="false" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                 <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>
                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                  </div>
            
          </div>
 
    </form>
</body>
</html>
