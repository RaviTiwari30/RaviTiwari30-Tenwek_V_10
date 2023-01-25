<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Anatomic_Master.aspx.cs" Inherits="Design_Lab_Anatomic_Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Anatomic Master</b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:HiddenField ID="hdnId" runat="server" />           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>

             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                                             
                        <div class="col-md-3">
                            <label class="pull-left">Anatomic Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAnatomicName" runat="server" class="requiredField" placeHolder="Enter Anatomic Name here"></asp:TextBox> 
                             <asp:Label ID="lblAnatomicID" runat="server" Visible="false"></asp:Label>                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"> Is Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">                  
                            <asp:RadioButton ID="btnYes" Text="Yes" runat="server" Checked="true" GroupName="IsActive" />
                            <asp:RadioButton ID="btnNo" Text="No" runat="server" GroupName="IsActive" />
                        </div>
                    </div>                   
                </div>
                 <div class="col-md-1"></div>
            </div>
        </div>

         <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
                <asp:Button ID="btncler" runat="server" Text="Clear" OnClick="btnClear_Click" />                                              
            </div>
        </div>
          <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Anatomic Details
            </div>
             <div class="POuter_Box_Inventory">            
           <asp:GridView ID="grdPanel" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnSelectedIndexChanged="grdPanel_SelectedIndexChanged">
                    <Columns>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="SrNo.">
                    <ItemTemplate>
                        <asp:Label ID="lblsrNo" runat="server" Text='<%# Eval("ID") %>'/>
                    </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Anatomic Name">
                        <ItemTemplate>
                            <asp:Label ID="lblAnatomicName" runat="server" Text='<%# Eval("AnatomicName")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                         <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Active Status">
                        <ItemTemplate>
                            <asp:Label ID="LblIsActive" runat="server" Text='<%# Eval("IsActive")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                         <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Created Date Time">
                        <ItemTemplate>
                            <asp:Label ID="lblCreatedDateTIme" runat="server" Text='<%# Eval("CreatedDateTIme")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                         <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Created By">
                        <ItemTemplate>
                            <asp:Label ID="lbaCreatedBy" runat="server" Text='<%# Eval("NAME")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                         <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Updated Date Time">
                        <ItemTemplate>
                            <asp:Label ID="lbaUpdatedDateTime" runat="server" Text='<%# Eval("UpdatedDateTime")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                         <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Updated By">
                        <ItemTemplate>
                            <asp:Label ID="lbaUpdatedBy" runat="server" Text='<%# Eval("NAME")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField> 

                        <%--  <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Edit">
                        <ItemTemplate>
                            <asp:CommandField ShowSelectButton="True" ItemStyle-HorizontalAlign="Center" ButtonType="Button" SelectText="" SelectImageUrl="../../Images/edit.png" />
 
                            <img id="imgEdit" src="../../Images/edit.png" onclick="Edit(this);" style="cursor: pointer;" title="Click To Edit" />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField> --%>    
                                                      
                    <asp:CommandField ShowSelectButton="True" ItemStyle-HorizontalAlign="Center" HeaderText="Edit" HeaderStyle-CssClass="GridViewHeaderStyle"  ButtonType="Button" SelectText="Edit" SelectImageUrl="../../Images/edit.png" />
                    </Columns>
                </asp:GridView> 
        </div>
        </div>
    </div>

</asp:Content>

