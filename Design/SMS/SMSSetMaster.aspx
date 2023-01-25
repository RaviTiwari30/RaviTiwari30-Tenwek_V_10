<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SMSSetMaster.aspx.cs" Inherits="Design_SMS_SMSSetMaster" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        function validate() {
            if ($.trim( $("#txtSetName").val()) == "") {
                $("#lblMsg").text('Please Enter Template Name');
                $("#txtSetName").focus();
                return false;
            }
            if ($("#chklInfo input[type=checkbox]:checked").length == 0) {
                $("#lblMsg").text('Please Check Patient Info.');
               
                return false;
            }

            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
    </script>
    <Ajax:ScriptManager ID="sm1" runat="server" />

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>SMS Template Master </b>
            <br />

            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
             <table style="width:100%;border-collapse:collapse">
                 <tr>
                     <td style="width:20%;text-align:right">
                         Template Name :&nbsp;
                     </td>
                      <td style="width:80%;text-align:left">
                       <asp:TextBox ID="txtSetName" Width="220px" ClientIDMode="Static" runat="server" MaxLength="50" AutoCompleteType="Disabled"></asp:TextBox>
                          <span style="color: red; font-size: 10px;" >*</span>
                          <asp:Label ID="lblSetID" runat="server" Visible="false"></asp:Label>
                     </td>
                 </tr>
                 <tr>
                     <td style="width:20%;text-align:right">
                         Patient Info. :&nbsp;
                     </td>
                     <td  style="width:80%;text-align:left">
                         <asp:CheckBoxList ID="chklInfo" ClientIDMode="Static" runat="server"  RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="6">

                         </asp:CheckBoxList>
                     </td>
                 </tr>
                 <tr runat="server" visible="false" id="trActive">
                      <td style="width:20%;text-align:right">
                         Active :&nbsp;
                     </td>
                     <td  style="width:80%;text-align:left">
                         <asp:RadioButtonList ID="rdoActive" runat="server" RepeatDirection="Horizontal">
                             <asp:ListItem Text="Yes" Value="1" Selected="True"></asp:ListItem>
                             <asp:ListItem Text="No" Value="0" ></asp:ListItem>
                         </asp:RadioButtonList>
                     </td>
                 </tr>
             </table>
             </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
             <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click" Text="Save" OnClientClick="return validate()" />&nbsp;&nbsp;
             <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" OnClick="btnCancel_Click" Text="Cancel"  Visible="false" />
             </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
         <div class="POuter_Box_Inventory" style="text-align: center;">
               <asp:GridView ID="grdSMSSet" runat="server" AutoGenerateColumns="false"  CssClass="GridViewStyle" OnSelectedIndexChanged="grdSMSSet_SelectedIndexChanged">
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                             <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                         <ItemStyle CssClass="GridViewLabItemStyle" />
                         <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="Template Name " HeaderStyle-Width="180px">
                        <ItemTemplate>
                          <asp:Label ID="lblSetName" runat="server"  Text='<%#Eval("SetName") %>'></asp:Label>  
                              <asp:Label ID="lblSetID" runat="server" Visible="false" Text='<%#Eval("ID") %>'></asp:Label>
                            
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                         <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Patient Info " HeaderStyle-Width="420px">
                        <ItemTemplate>
                           
                              <asp:Label ID="lblPatientInfo" runat="server"  Text='<%#Eval("PatientInfo") %>'></asp:Label>
                           <asp:Label ID="lblColumnInfo" runat="server"  Visible="false" Text='<%#Eval("ColumnInfo") %>'></asp:Label>  
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                         <HeaderStyle CssClass="GridViewHeaderStyle" Width="420px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="IsActive" HeaderStyle-Width="60px">
                        <ItemTemplate>
                           
                              <asp:Label ID="lblIsActive" runat="server"  Text='<%#Eval("IsActive") %>'></asp:Label>
                            
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                         <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                    </asp:TemplateField>
                     <asp:CommandField ShowSelectButton="True" SelectText="Edit" ButtonType="Image" SelectImageUrl="~/Images/edit.png" HeaderText="Edit" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    </asp:CommandField>
                    </Columns>

                   </asp:GridView>
             </div>

            </asp:Panel>
        </div>
</asp:Content>

