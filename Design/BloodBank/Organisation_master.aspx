<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Organisation_master.aspx.cs" Inherits="Design_BloodBank_Organisation_master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        var oldgridcolor;
        function SetMouseOver(element) {
            oldgridcolor = element.style.backgroundColor;
            element.style.backgroundColor = '#C2D69B';
            element.style.cursor = 'pointer';
            element.style.textDecoration = 'underline';
        }
        function SetMouseOut(element) {
            element.style.backgroundColor = oldgridcolor;
            element.style.textDecoration = 'none';
        }
        function email() {
            var emailaddress = $('#<%=txtEmail.ClientID %>').val();
        var emailexp = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

        if (!emailexp.test(emailaddress)) {
            alert('Please enter valid email address.');
            $('#<%=txtEmail.ClientID %>').focus();
            return false;
        }
        else {
            return true;
        }
    }
    $(document).ready(function () {
        $('#<%=btnSave.ClientID %>').click(function () {
         if ($('#<%=ddlState.ClientID %>').val() > 0) {
         return true;
     }
     else {
         alert('Please select State');
         return false;
     }
 });
 });
function up() {

    if ($('#<%=ddlState.ClientID %>').val() > 0) {
        return true;
        $('#<%=btnUpdate.ClientID %>').attr("disabled", true);
}
else {
    alert('Please select State');
    return false;
}

}
function clearform() {
    $(':text, textarea').val('');
    $('(#<%=ddlState.ClientID%>) option:nth-child(1)').attr('selected', '0');
   $(".rad").find(':radio').attr('checked', 'Yes');
}
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Organisation Master</b><br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Organisation Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtOrganisation" runat="server" CssClass="requiredField" TabIndex="1"
                                ToolTip="Enter Name">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtOrganisation"
                                ErrorMessage="*" ValidationGroup="btnsave"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAddress" runat="server" MaxLength="100" ToolTip="Enter Address" TabIndex="2"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                City
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCity" runat="server" MaxLength="50" ToolTip="Enter City" TabIndex="3" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                State
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlState" runat="server" ToolTip="Select State" TabIndex="4">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Pincode
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPinCode" runat="server" MaxLength="6" ToolTip="Enter PinCode" TabIndex="5" CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbPin" runat="server" FilterType="Numbers" TargetControlID="txtPinCode"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Phone No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPhoneNo" runat="server" MaxLength="20" ToolTip="Enter PhoneNo" TabIndex="6" CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbPhone" runat="server" FilterType="Numbers" TargetControlID="txtPhoneNo"></cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                MobileNo
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMobileNo" runat="server" MaxLength="20" ToolTip="Enter MobileNo" TabIndex="7" CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" FilterType="Numbers" TargetControlID="txtMobileNo"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                FaxNo
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFaxNo" runat="server" MaxLength="50" ToolTip="Enter FaxNo" TabIndex="8" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Email
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmail" runat="server" MaxLength="50" ToolTip="Enter Email" TabIndex="9" onblur="email(this);" CssClass="ItDoseTextinputText"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblActive" runat="server" RepeatDirection="Horizontal" TabIndex="10" class="rad">
                                <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click"
                                TabIndex="8" CssClass="ItDoseButton" OnClientClick="if(Page_ClientValidate()){__doPostBack;this.disabled=true;}"
                                UseSubmitBehavior="false" ValidationGroup="btnsave" />
                            <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click" Text="Update"
                                CssClass="ItDoseButton" ValidationGroup="btnsave" />
                            <asp:Button ID="btnCancel" runat="server" OnClick="btncancel_Click" CssClass="ItDoseButton"
                                Text="Cancel" />
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <asp:GridView ID="grdOrganisation" runat="server" AutoGenerateColumns="False" Width="100%"
                AllowPaging="true" PageSize="10" CssClass="GridViewStyle" OnSelectedIndexChanged="grdOrganisation_SelectedIndexChanged"
                OnPageIndexChanging="grdOrganisation_PageIndexChanging" OnRowDataBound="grdOrganisation_RowDataBound">
                <PagerTemplate>
                    <strong><b>Number of Pages:
                        <%=grdOrganisation.PageCount%>
                    </b></strong>&nbsp;&nbsp;
                    <asp:Button ID="btnFirst" runat="server" CommandName="Page" ToolTip=" Select First" CssClass="ItDoseButton"
                        CommandArgument="First" Text="<<" />
                    <asp:Button ID="btnPrev" runat="server" CommandName="Page" ToolTip="Select Prev" CssClass="ItDoseButton"
                        CommandArgument="Prev" Text="<" />
                    <asp:Button ID="btnNext" runat="server" CommandName="Page" ToolTip="Select Next" CssClass="ItDoseButton"
                        CommandArgument="Next" Text=">" />
                    <asp:Button ID="btnLast" runat="server" CommandName="Page" ToolTip="Select Last" CssClass="ItDoseButton"
                        CommandArgument="Last" Text=">>" />
                </PagerTemplate>
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Id" Visible="false">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Organisaction" HeaderText="Organisaction">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Address" HeaderText="Address">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="City" HeaderText="City">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="State" HeaderText="State">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PinCode" HeaderText="PinCode">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PhoneNo" HeaderText="PhoneNo">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="MobileNo" HeaderText="MobileNo">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FaxNo" HeaderText="FaxNo">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="EmailID" HeaderText="EmailID">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="IsActive" HeaderText="Active">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="20px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="IsActive" Visible="false">
                        <ItemTemplate>
                            <div style="display: none;">
                                <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("ID")+"#"+Eval("Organisaction")+"#"+Eval("Address")+"#"+Eval("City")+"#"+Eval("State")+"#"+Eval("PinCode")+"#"+Eval("PhoneNo")+"#"+Eval("MobileNo")+"#"+Eval("FaxNo")+"#"+Eval("EmailID")+"#"+Eval("IsActive")%>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                    </asp:TemplateField>
                    <asp:CommandField ShowSelectButton="True" SelectText="Edit" HeaderText="Edit">
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                    </asp:CommandField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
