<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="UserManager.aspx.cs" Inherits="Design_EDP_UserManager" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Role Management</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <table>
                <tr style="width:80%">
                    <td style="text-align:right;width:35%;vertical-align:top">
            <label >Privilege :</label></td>
                    <td style="width:40%;vertical-align:top">
            <asp:DropDownList ID="ddlRole" runat="server"  Width="300px" />
            </td><td style="width:40%;text-align:left;vertical-align:top">
                <asp:Button ID="btnUser" runat="server" Text="Search" OnClick="btnUser_Click" CssClass="ItDoseButton" Visible="true" CausesValidation="False" />
            <asp:Button ID="btnRole" runat="server" Text="New Role" CssClass="ItDoseButton" CausesValidation="False" OnClick="btnRole_Click" />
                <asp:Button ID="btnEditRole" runat="server" Text="Edit Role" CssClass="ItDoseButton" CausesValidation="False" OnClick="btnEditRole_Click" />
                 </td>
           </tr> </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Users Detail
            </div>
            <div style="text-align: center;">
                <asp:Panel ID="pnlgv1" runat="server" ScrollBars="vertical" Height="500px">
                    <asp:GridView ID="grdRole" AutoGenerateColumns="False" runat="server" CssClass="GridViewStyle" OnRowCommand="grdRole_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("Name") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="User Name" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("UserName") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Privilege" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="AEdit" ImageUrl="~/Images/login.png" CommandArgument='<%# Eval("Employee_ID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Login" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbLogin" runat="server" CausesValidation="false" CommandName="login" ImageUrl="~/Images/reg.jpg" Visible='<%# Util.GetBoolean(Eval("ltype")) %>' CommandArgument='<%# Eval("Employee_ID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Password" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbPassword" runat="server" CausesValidation="false" CommandName="Password" ImageUrl="~/Images/edit.png" Visible='<%# !Util.GetBoolean(Eval("ptype")) %>' CommandArgument='<%# Eval("Employee_ID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                           <%--  <asp:TemplateField HeaderText="Edit" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEditDetails" runat="server" CausesValidation="false" CommandName="AEditDetails" ImageUrl="~/Images/edit.png"  CommandArgument='<%# Eval("Employee_ID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>--%>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
    </div>


    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CausesValidation="False" CssClass="ItDoseButton"/>
    </div>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlFilter" Width="350px" Style="display: none">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Privilege Details
        </div>
        <table style="width: 300px">
            <tr>
                <td style="width: 75px; text-align: right;">Employee :&nbsp;</td>
                <td style="width: 200px">
                    <asp:Label ID="lblEmpName" runat="server" CssClass="ItDoseLabelSp"
                        Font-Bold="true"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 75px; text-align: right;">Privilege :&nbsp;</td>
                <td style="width: 200px">
                    <asp:DropDownList ID="ddlRoleRight" runat="server" Width="220px">
                    </asp:DropDownList>
                </td>
            </tr>
        </table>
        <div class="filterOpDiv">
            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                Text="Save" ValidationGroup="Save" Width="65px" CausesValidation="False" />
            <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                Text="Cancel" Width="65px" />
        </div>
    </asp:Panel>

    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server"
        CancelControlID="btnCancel"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnlPassowrd" runat="server" CssClass="pnlFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div1" runat="server">
            Login Details
        </div>
        <div class="content">
            <label class="labelForPO">
                Name :</label>
            <asp:Label ID="lblEmp" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp"></asp:Label>
            <br />
            <br />

            <label class="labelForPO">
                UserName :</label>
            <asp:TextBox ID="txtUser" runat="server" CssClass="ItDoseLabel" ValidationGroup="Login"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rqPass" ValidationGroup="Login" runat="server" ControlToValidate="txtUser" ErrorMessage="Enter User Name"
                Text="*" Display="None" />
            <br />
            <label class="labelForPO">
                Password :</label>
            <asp:TextBox ID="txtPassword" ValidationGroup="Login" runat="server" CssClass="ItDoseLabel" TextMode="Password"></asp:TextBox>
            <asp:RequiredFieldValidator ValidationGroup="Login" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPassword" ErrorMessage="Enter Password"
                Text="*" Display="None" />

            <br />
            <label class="labelForPO">
                Confirm Pwd :</label>
            <asp:TextBox ID="txtConfirm" ValidationGroup="Login" runat="server" CssClass="ItDoseLabel" TextMode="Password"></asp:TextBox>
            <asp:CompareValidator ValidationGroup="Login" ID="CompareValidator2" runat="server" ControlToCompare="txtPassword"
                ControlToValidate="txtConfirm" ErrorMessage="Confirm Passoword Not Match" SetFocusOnError="True" Display="None">*</asp:CompareValidator><br />
            <div class="filterOpDiv">
                <asp:Button ID="btnSavePassword" ValidationGroup="Login" runat="server" CssClass="ItDoseButton" OnClick="btnSavePassword_Click"
                    Text="Save" Width="65px" />
                <asp:Button ID="btnCancelPassword" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                    Text="Cancel" Width="55px" />
            </div>
        </div>

    </asp:Panel>

    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server"
        CancelControlID="btnCancelPassword"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlPassowrd"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="Panel1" runat="server" CssClass="pnlFilter" Width="500px">
        <div class="Purchaseheader" id="Div2" runat="server" style="width: 495px">
            Change Password
        </div>
        <table style="width: 500px">
            <tr>
                <td style="width: 105px; text-align: right;">Name :
                </td>
                <td style="width: 300px;text-align:left">
                    <asp:Label ID="lblemp1" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 105px; text-align: right;">Password :
                </td>
                <td style="width: 300px;text-align:left">
                    <asp:TextBox ID="txtpwd" runat="server" ValidationGroup="Pwd" MaxLength="20" CssClass="ItDoseLabel" TextMode="Password"></asp:TextBox>
                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>

                </td>
            </tr>
            <tr>
                <td style="width: 125px; text-align: right;">Confirm Password :
                </td>
                <td style="text-align:left">
                    <asp:TextBox ID="txtcPwd" runat="server" ValidationGroup="Pwd" MaxLength="20" CssClass="ItDoseLabel" TextMode="Password"></asp:TextBox>
                    <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>

                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtpwd" ValidationGroup="Pwd"
                        ControlToValidate="txtcPwd" ErrorMessage="Confirm Password Not Match"></asp:CompareValidator>
                    <asp:RequiredFieldValidator ValidationGroup="Pwd" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtpwd" ErrorMessage="Enter Password"
                        Text="*" Display="None" />
                </td>
            </tr>
        </table>

        <div class="filterOpDiv" style="text-align: center">


            <asp:Button ID="btnSavePwd" runat="server" CssClass="ItDoseButton" OnClick="btnSavePwd_Click"
                Text="Save" ValidationGroup="Pwd" />
            <asp:Button ID="btnCancel1" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                Text="Cancel" />
        </div>


    </asp:Panel>

    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server"
        CancelControlID="btnCancel1"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel1"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnlRole" runat="server" CssClass="pnlFilter" Width="600px"   >
        <div class="Purchaseheader" id="Div3" runat="server">
            New Role
        </div>
        <table>
            <tr>
                <td style="text-align:right;">Role :
                </td>
                <td style="text-align:left;" >
                    <asp:DropDownList ID="ddlRole1" runat="server" Visible="false" AutoPostBack="true" OnSelectedIndexChanged="ddlRole1_SelectedIndexChanged" Width="216px"  CssClass="ItDoseDropdownbox" ></asp:DropDownList>
                    <asp:TextBox ID="txtRole" runat="server"  MaxLength="50" Visible="false" CssClass="ItDoseTextinputText"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Specify Role" ControlToValidate="txtRole" Text="*" Display="None" ValidationGroup="role"></asp:RequiredFieldValidator>

                </td>
            </tr>
            <tr>
                <td style="text-align:right">Is Department :
                </td>
                <td style="width: 69px"><asp:RadioButtonList ID="rbtrolldeptlsit" runat="server" RepeatDirection="Horizontal" Width="152px">
                        <asp:ListItem>Yes</asp:ListItem>
                        <asp:ListItem Selected="True">No</asp:ListItem>
                    </asp:RadioButtonList></td>
            </tr>
           

            <tr>
                <td >Can Generate PR And PO or GRN :
                </td><td style="width: 69px"> <asp:RadioButtonList ID="rbtnStore" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="rbtnStore_SelectedIndexChanged" AutoPostBack="true" Width="152px">
                        <asp:ListItem Value="1">Yes</asp:ListItem>
                        <asp:ListItem Selected="True" Value="0">No</asp:ListItem>
                    </asp:RadioButtonList></td>
            </tr>
            
           
              <tr>
                <td style="text-align:right">Generate Menu :
                </td><td><asp:DropDownList ID="ddldeptformenu" runat="server" CssClass="ItDoseDropdownbox" Width="225px"></asp:DropDownList></td>
            </tr>
            
            <tr>
                <td style="text-align:right"><asp:Label ID="lblRightsFor" runat="server" Text="Rights for:" Visible="false"></asp:Label> 
                </td><td>  <asp:CheckBox ID="rbtMed" Text="Medical" runat="server" Visible="false" />                    
                    <asp:CheckBox ID="rbtGen" Text="General" runat="server" Visible="false" /></td>
            </tr>
            <tr >
                <td colspan="2" style="text-align:center" >
                   <br />
                </td><td></td>
            </tr>

             
        </table>







        <div  style="text-align:center">
            <asp:Button ID="btnSaveRole" runat="server" CssClass="ItDoseButton" OnClick="btnSaveRole_Click"
                Text="Save" ValidationGroup="role" />
              <asp:Button ID="btnUpdateRole" runat="server" CssClass="ItDoseButton" OnClick="btnUpdateRole_Click"
                Text="Update"  />
            <asp:Button ID="btnCancelRole" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                Text="Cancel" />

        </div>


    </asp:Panel>
    <asp:ValidationSummary ID="vs1" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="Login" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="Pwd" />

    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="role" />
    <div  style="display:none;"> <asp:Button ID="btnHide" runat="server" />  </div>
    <cc1:ModalPopupExtender ID="MdpRole" runat="server" CancelControlID ="btnCancelRole" DropShadow="true" TargetControlID="btnHide" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlRole"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>


</asp:Content>
