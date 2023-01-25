<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="UserManager_New.aspx.cs" Inherits="Design_EDP_UserManager_New" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function Extender_Onchange(sender, args) {
            if ($.trim($("#txtInitial").val()) != "")
                GeneratePreview();
        }
        $(function () {
            GeneratePreview();
            $("#txtFinYear").attr('disabled', 'disabled');
        });
        function GeneratePreview() {
            $('#lblPreview').text('');
            if (($.trim($("#txtInitial").val()) != "")) {
                $('#ddlSeparator2 option[value="' + $('#ddlSeparator1').val() + '"]').attr('selected', true);
                var initial = $('#txtInitial').val().toUpperCase();
                var Separator1 = $('#ddlSeparator1').val();
                var FinYear = "";
                if ($.trim($('#txtFinYear').val()) != "")
                    FinYear = GetFinancialYear();
                var Separator2 = $('#ddlSeparator2').val();
                var Length = $('#ddlLength option:selected').text();
                $('#lblPreview').text(initial + Separator1 + FinYear + Separator2 + Length);
            }
            else {
                $('#lblPreview').text('');
            }

        }
        function GetFinancialYear() {
            var data;
            $.ajax({
                url: "Services/EDP.asmx/GetFinYear",
                data: '{date:"' + $('#txtFinYear').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    data = mydata.d;

                }
            });
            return data;
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Role Management</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%; border-collapse: collapse">
                <tr >
                    <td style="text-align: right; width: 20%; ">
                        Privilege :&nbsp;</td>
                    <td style="width: 40%; ">
                        <asp:DropDownList ID="ddlRole" runat="server" Width="300px" />
                    </td>
                    <td style="width: 40%; text-align: left; vertical-align: top">
                        <asp:Button ID="btnUser" runat="server" Text="Search" OnClick="btnUser_Click" CssClass="ItDoseButton" Visible="true" CausesValidation="False" />
                        <input type="button" class="ItDoseButton" value="New Role" onclick="createRole()" />
                         <input type="button" class="ItDoseButton" value="Edit Role" onclick="editRole()" style="display:none" />
                    </td>
                </tr>
            </table>
        </div>
               <div class="POuter_Box_Inventory">
    <asp:Panel ID="pnlRole" runat="server"  ClientIDMode="Static" style="display:none">
        <div class="Purchaseheader" >
            New Role
        </div>
        <table style="width: 100%; border-collapse: collapse">
            
            <tr>
                <td style="text-align: right; width: 40%">Role :&nbsp;
                </td>
                <td style="text-align: left; width: 60%">
                    <asp:DropDownList ID="ddlRole1" runat="server" ClientIDMode="Static" style="display:none" Width="216px"></asp:DropDownList>
                    <asp:TextBox ID="txtRole" AutoCompleteType="Disabled" runat="server" style="display:none" MaxLength="50" ClientIDMode="Static"></asp:TextBox>
                    <span style="color: red; font-size: 10px;" class="shat">*</span>


                </td>
            </tr>
            <tr>
                <td style="text-align: right">Is Department :&nbsp;
                </td>
                <td style="width: 60%; text-align: left">                   
                                <asp:RadioButtonList ID="rblIsDepartment" ClientIDMode="Static" onclick="checkDept()"  runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="0">No</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                            
            </tr>
            <tr  id="trIsUniversal" style="display:none">
                <td style="text-align: right">Is Universal Format :&nbsp;
                </td>
                <td style="width: 60%; text-align: left">
                    <table style="width:100%">
                        <tr>
                            <td style="text-align:left">                          
                    <asp:RadioButtonList ID="rblIsUniversal" onclick="checkFormat()" ClientIDMode="Static"  runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                        <asp:ListItem Value="0">No</asp:ListItem>
                    </asp:RadioButtonList></td>
                      <td style="text-align:left">                                       
                    <input type="button" class="ItDoseButton" id="btnUniversalFormat" value="Universal Format" onclick="showUniversalFormat()"/>
                  </td> </tr>
                         </table>
                        </td>
            </tr>
            <tr  id="trFormat" style="text-align:center;width:100%;display:none">
                <td style="text-align: center;width:100%" colspan="2">
                    <table style="border: 0; border-collapse: collapse;text-align:center;width:100%">
                        <tr>
                            <td class="GridViewHeaderStyle" style="width:140px">Type</td>
                            <td class="GridViewHeaderStyle" style="width:40px">Is&nbsp;Universal</td>
                            <td class="GridViewHeaderStyle" style="width:40px">Initial&nbsp;Character</td>                            
                            <td class="GridViewHeaderStyle" style="width:40px">Separator</td>
                            <td class="GridViewHeaderStyle" style="width:120px">Financial&nbsp;Year</td>
                            <td class="GridViewHeaderStyle" style="width:40px">Separator</td>
                            <td class="GridViewHeaderStyle" style="width:40px">Length</td>
                            <td class="GridViewHeaderStyle" style="width:120px">Preview</td>
                            <td class="GridViewHeaderStyle" style="width:60px">&nbsp;</td>                           
                        </tr>                       
                        <tr>
                            <td class="GridViewItemStyle">
                              <asp:DropDownList ID="ddlType" runat="server" ClientIDMode="Static" Width="140px">
                                    </asp:DropDownList>
                                      </td>
                             <td class="GridViewItemStyle">
                                <asp:CheckBox ID="chkIsUniversal" ClientIDMode="Static" runat="server" onclick="universalCheck()" />
                          
                                  </td>
                            <td class="GridViewItemStyle">
                                <asp:TextBox ID="txtInitial" AutoCompleteType="Disabled" runat="server" MaxLength="6" onkeyup="GeneratePreview()" ClientIDMode="Static" Width="60px"></asp:TextBox>
                           <span style="color: red; font-size: 10px;" class="shat">*</span>
                                  </td>
                           
                            <td class="GridViewItemStyle">
                                <asp:DropDownList ID="ddlSeparator1" runat="server" Width="40px" ClientIDMode="Static" onChange="GeneratePreview()">
                                    <asp:ListItem Value=""></asp:ListItem>
                                     <asp:ListItem Value="/">/</asp:ListItem>
                                    <asp:ListItem Value="-">-</asp:ListItem>
                                </asp:DropDownList></td>
                            <td class="GridViewItemStyle"  style="width:140px">
                                <asp:CheckBox ID="chkFinYear" ClientIDMode="Static" runat="server" onclick="checkFinYear()" />
                             
                                <asp:TextBox ID="txtFinYear"  AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" Width="90px"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" OnClientDateSelectionChanged="Extender_Onchange" BehaviorID="calendar1" runat="server" TargetControlID="txtFinYear" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:DropDownList ID="ddlSeparator2" Width="40px" runat="server" ClientIDMode="Static" onChange="GeneratePreview()">
                                    <asp:ListItem Value=""></asp:ListItem>
                                     <asp:ListItem Value="/">/</asp:ListItem>
                                    <asp:ListItem Value="-">-</asp:ListItem>
                                </asp:DropDownList></td>
                            <td class="GridViewItemStyle">
                                <asp:DropDownList ID="ddlLength" runat="server" ClientIDMode="Static"  onChange="GeneratePreview()">
                                    <asp:ListItem Selected="True" Value="6" >000001</asp:ListItem>
                                    <asp:ListItem Value="7">0000001</asp:ListItem>
                                    <asp:ListItem Value="8">00000001</asp:ListItem>
                                    <asp:ListItem Value="9">000000001</asp:ListItem>
                                    <asp:ListItem Value="10">0000000001</asp:ListItem>
                                    <asp:ListItem Value="11">00000000001</asp:ListItem>
                                    <asp:ListItem Value="12">000000000001</asp:ListItem>
                                </asp:DropDownList></td>
                            <td class="GridViewItemStyle" style="width:120px">
                                <asp:Label ID="lblPreview" runat="server" ClientIDMode="Static" ></asp:Label>
                            </td>
                            <td class="GridViewItemStyle" style="width:60px">
                                <input type="button" class="ItDoseButton" value="Add" onclick="addFormat()" />
                                </td>


                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                     <table id="tbSelected"  rules="all" border="1" style="border-collapse: collapse; width: 100%; display:none" class="GridViewStyle">
                                <tr id="formatHeader">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 140px; text-align:left">Type</th>
                                     <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align:left">Is&nbsp;Universal</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 120px; text-align:left">Initial&nbsp;Character</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align:left">Separator1</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align:left">Financial&nbsp;Year</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align:left">Separator2</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align:left">Length</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left">Preview</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:left">&nbsp;</th>
                                </tr>
                               
                            </table>
                </td>
            </tr>
            <tr style="text-align: right">
                <td>Can Generate PR And PO or GRN :&nbsp;
                </td>
                <td style="width: 60%; text-align: left">
                    <asp:RadioButtonList ID="rbtnStore" runat="server" onclick="checkStore()" ClientIDMode="Static" RepeatDirection="Horizontal" >
                        <asp:ListItem Value="1">Yes</asp:ListItem>
                        <asp:ListItem Selected="True" Value="0">No</asp:ListItem>
                    </asp:RadioButtonList></td>
            </tr>
            <tr>
                <td style="text-align: right">Generate Menu :&nbsp;
                </td>
                <td style="text-align: left">
                    <asp:DropDownList ID="ddlDeptMenu" ClientIDMode="Static" runat="server" Width="225px"></asp:DropDownList></td>
            </tr>
            <tr id="trcheckRight"  style="display:none">
                <td style="text-align: right">
                    <asp:Label ID="lblRightsFor" ClientIDMode="Static" runat="server" Text="Rights For :&nbsp;"  style="display:none"></asp:Label>
                </td>
                <td style="text-align: left">
                    <asp:CheckBox ID="chkMed" ClientIDMode="Static" Text="Medical" runat="server"  />
                    <asp:CheckBox ID="chkGen" ClientIDMode="Static" Text="General" runat="server"  /></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <br />
                </td>
                <td></td>
            </tr>
        </table>
        <div style="text-align: center">
            <input type="button" class="ItDoseButton" value="Save" id="btnSaveRole" onclick="saveRole()" />
           <input type="button" class="ItDoseButton" value="Update" id="btnUpdateRole" onclick="updateRole()" />&nbsp;
           <input type="button" class="ItDoseButton" value="Cancel" id="btnCancelRole" onclick="cancelRole()" />           
        </div>


    </asp:Panel>
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
                                    <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="AEdit" ImageUrl="~/Images/login.png" CommandArgument='<%# Eval("EmployeeID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Login" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbLogin" runat="server" CausesValidation="false" CommandName="login" ImageUrl="~/Images/reg.jpg" Visible='<%# Util.GetBoolean(Eval("ltype")) %>' CommandArgument='<%# Eval("EmployeeID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Password" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbPassword" runat="server" CausesValidation="false" CommandName="Password" ImageUrl="~/Images/edit.png" Visible='<%# !Util.GetBoolean(Eval("ptype")) %>' CommandArgument='<%# Eval("EmployeeID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--  <asp:TemplateField HeaderText="Edit" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEditDetails" runat="server" CausesValidation="false" CommandName="AEditDetails" ImageUrl="~/Images/edit.png"  CommandArgument='<%# Eval("EmployeeID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>--%>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
    </div>


    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CausesValidation="False" CssClass="ItDoseButton" />
    </div>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlFilter" Width="360px" Style="display: none">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Privilege Details
        </div>
        <table style="width: 300px;border-collapse:collapse">
            <tr>
                <td style="width: 80px; text-align: right;">Employee&nbsp;:&nbsp;</td>
                <td style="width: 200px">
                    <asp:Label ID="lblEmpName" runat="server" CssClass="ItDoseLabelSp"
                        Font-Bold="true"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 80px; text-align: right;">Privilege :&nbsp;</td>
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
            <asp:TextBox ID="txtUser" runat="server"  ValidationGroup="Login"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rqPass" ValidationGroup="Login" runat="server" ControlToValidate="txtUser" ErrorMessage="Enter User Name"
                Text="*" Display="None" />
            <br />
            <label class="labelForPO">
                Password :</label>
            <asp:TextBox ID="txtPassword" ValidationGroup="Login" runat="server"  TextMode="Password"></asp:TextBox>
            <asp:RequiredFieldValidator ValidationGroup="Login" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPassword" ErrorMessage="Enter Password"
                Text="*" Display="None" />

            <br />
            <label class="labelForPO">
                Confirm Pwd :</label>
            <asp:TextBox ID="txtConfirm" ValidationGroup="Login" runat="server"  TextMode="Password"></asp:TextBox>
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

    <asp:Panel ID="Panel1" runat="server" CssClass="pnlFilter" Width="500px" Style="display:none">
        <div class="Purchaseheader" id="Div2" runat="server" style="width: 495px">
            Change Password
        </div>
        <table style="width: 500px;border-collapse:collapse">
            <tr>
                <td style="width: 105px; text-align: right;">Name :&nbsp;
                </td>
                <td style="width: 300px; text-align: left">
                    <asp:Label ID="lblemp1" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 105px; text-align: right;">Password :&nbsp;
                </td>
                <td style="width: 300px; text-align: left">
                    <asp:TextBox ID="txtpwd" runat="server" ValidationGroup="Pwd" MaxLength="20"  TextMode="Password"></asp:TextBox>
                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>

                </td>
            </tr>
            <tr>
                <td style="width: 125px; text-align: right;">Confirm Password :&nbsp;
                </td>
                 <td style="width: 300px; text-align: left">
                    <asp:TextBox ID="txtcPwd" runat="server" ValidationGroup="Pwd" MaxLength="20"  TextMode="Password"></asp:TextBox>
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
    <cc1:ModalPopupExtender ID="mpopUnFormat" runat="server" BehaviorID="mpopUnFormat"
        CancelControlID="btnCancelUnFormat"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUniversialFormat"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>
    <asp:ValidationSummary ID="vs1" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="Login" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="Pwd" />

    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="role" />
    <div style="display: none;">
        <asp:Button ID="btnHide" runat="server" />
    </div>
  

    <script type="text/javascript">
        function checkDept() {
            if ($("#rblIsDepartment input[type=radio]:checked").val() == "1") {
                $("#trIsUniversal").show();

            }
            else {
                $("#trIsUniversal").hide();
            }
            $("#rblIsUniversal").find("input[value = '1']").attr("checked", "checked");
        }
        function checkFormat() {
            if ($("#rblIsUniversal input[type=radio]:checked").val() == "0") {
                $("#trFormat").show();

            }
            else {
                $("#trFormat").hide();
            }
            clearAllFormat();
        }
        function clearAllFormat() {
            $("#ddlType,#ddlSeparator1,#ddlSeparator2,#ddlLength").prop('selectedIndex', '0').removeAttr('disabled');
            $("#txtInitial,#txtFinYear").val('').removeAttr('disabled');
            $("#lblPreview").text('');
            $("#txtFinYear").attr('disabled', 'disabled');
            $("#chkFinYear,#chkIsUniversal").attr('checked', false).removeAttr('disabled');
            $("#tbSelected tr:not(#formatHeader)").remove();
            $('#tbSelected').removeAttr('disabled').hide();

        }
        function clearFormat() {
            $("#ddlType,#ddlSeparator1,#ddlSeparator2,#ddlLength").prop('selectedIndex', '0').removeAttr('disabled');
            $("#txtInitial,#txtFinYear").val('').removeAttr('disabled');
            $("#lblPreview").text('');
            $("#txtFinYear").attr('disabled', 'disabled');
            $("#chkFinYear,#chkIsUniversal").attr('checked', false).removeAttr('disabled');
        }
        function checkFinYear() {
            if ($("#chkFinYear").is(':checked'))
                $("#txtFinYear").removeAttr('disabled');
            else
                $("#txtFinYear").val('').attr('disabled', 'disabled');
            GeneratePreview();
        }
    </script>
    <script type="text/javascript">
        function createRole() {
            clearAllData();
            $("#pnlRole,#txtRole,#btnSaveRole").show();           
            $("#btnUpdateRole,#btnCancelRole").hide();
        }
        function removeRows(rowid) {
            $(rowid).closest('tr').remove();
            if ($('#tbSelected tr:not(#formatHeader)').length == 0) {
                $('#tbSelected').hide();
            }

        }
        function checkDuplicateType(typeID) {
            var count = 0;
            $('#tbSelected tr:not(#formatHeader)').each(function () {
                if ($(this).find('#spnTypeID').text().trim() == typeID) {
                    count = count + 1;
                }
            });
            if (count == 0)
                return true;
            else
                return false;
        }
        function checkDupInitial(InitialCharacter) {
            var count = 0;
            $('#tbSelected tr:not(#formatHeader)').each(function () {
                if ($(this).find('#spnInitialCharacter').text().trim() == InitialCharacter) {
                    count = count + 1;
                }
            });
            if (count == 0)
                return true;
            else
                return false;
        }
        function universalCheck() {
            if ($("#chkIsUniversal").is(':checked')) {
                $('#txtInitial,#txtFinYear').val('').attr('disabled', 'disabled');
                $("#ddlSeparator1,#ddlSeparator2,#ddlLength").prop('selectedIndex', '0').attr('disabled', 'disabled');
                $("#chkFinYear").attr('disabled', 'disabled');
                $("#lblPreview").text('');
            }

            else {
                $('#txtInitial,#txtFinYear').val('').removeAttr('disabled');
                $("#ddlSeparator1,#ddlSeparator2,#ddlLength").prop('selectedIndex', '0').removeAttr('disabled');
                $("#chkFinYear").removeAttr('disabled');
            }
        }
        function addFormat() {
            $("#lblMsg").text('');
            if ($("#ddlType").val() != "0") {
                if (checkDuplicateType($("#ddlType").val())) {
                    $('#tbSelected').css('display', 'block');
                    var FinYear = "";
                    if ($.trim($('#txtFinYear').val()) != "")
                        FinYear = GetFinancialYear();
                    var isUniversalType = "No"; var isUniversalCheck = 0;
                    if ($('#chkIsUniversal').is(':checked')) {
                        isUniversalType = "YES";
                        isUniversalCheck = 1;
                    }
                    if (!($("#chkIsUniversal").is(':checked'))) {
                        if (($.trim($("#txtInitial").val()) != "")) {
                            if (checkDupInitial($("#txtInitial").val())) {

                                $('#tbSelected').append('<tr><td class="GridViewLabItemStyle"><span id="spnTypeName">' + $("#ddlType option:selected").text() + '</span><span id="spnTypeID" style="display:none">' + $("#ddlType").val() + '</span></td><td class="GridViewLabItemStyle"><span id="spnIsUniversal">' + isUniversalType + '</span><span id="spnIsUniversalType" style="display:none">' + isUniversalCheck + '</span></td><td class="GridViewLabItemStyle"><span id="spnInitialCharacter">' + $("#txtInitial").val() + '</span></td><td class="GridViewLabItemStyle"><span id="spnSeparator1">' + $("#ddlSeparator1").val() + '</span></td><td class="GridViewLabItemStyle"><span id="spnFinYearFormat">' + FinYear + '</span><span id="spnFinYear" style="display:none">' + $("#txtFinYear").val() + '</span></td><td class="GridViewLabItemStyle"><span id="spnSeparator2">' + $("#ddlSeparator2").val() + '</span><td class="GridViewLabItemStyle"><span id="spnLength">' + $("#ddlLength").val() + '</span><span id="spnTextLength" style="display:none">' + $("#ddlLength option:selected").text() + '</span> </td><td class="GridViewLabItemStyle"><span id="spnlPreview">' + $("#lblPreview").text() + '</span></td><td class="GridViewLabItemStyle"><img id="imgRemove" onclick="removeRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');
                                clearFormat();
                            }
                            else {
                                $("#lblMsg").text('Initial Character Already Added');
                                $("#txtInitial").focus();
                                return;
                            }
                        }
                        else {
                            $("#lblMsg").text('Please Enter Initial Character');
                            $("#txtInitial").focus();
                            return;
                        }
                    }
                    else {
                        $('#tbSelected').append('<tr><td class="GridViewLabItemStyle"><span id="spnTypeName">' + $("#ddlType option:selected").text() + '</span><span id="spnTypeID" style="display:none">' + $("#ddlType").val() + '</span></td><td class="GridViewLabItemStyle" style="text-align:center"><span id="spnIsUniversal">' + isUniversalType + '</span><span id="spnIsUniversalType" style="display:none">' + isUniversalCheck + '</span></td><td class="GridViewLabItemStyle"><span id="spnInitialCharacter">' + $("#txtInitial").val() + '</span></td><td class="GridViewLabItemStyle" style="text-align:center"><span id="spnSeparator1">' + $("#ddlSeparator1").val() + '</span></td><td class="GridViewLabItemStyle"><span id="spnFinYearFormat">' + FinYear + '</span><span id="spnFinYear" style="display:none">' + $("#txtFinYear").val() + '</span></td><td class="GridViewLabItemStyle" style="text-align:center"><span id="spnSeparator2">' + $("#ddlSeparator2").val() + '</span><td class="GridViewLabItemStyle" style="text-align:center"><span id="spnLength">' + $("#ddlLength").val() + '</span><span id="spnTextLength" style="display:none">' + $("#ddlLength option:selected").text() + '</span> </td><td class="GridViewLabItemStyle"><span id="spnlPreview">' + $("#lblPreview").text() + '</span></td><td class="GridViewLabItemStyle"><img id="imgRemove" onclick="removeRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');
                        clearFormat();
                    }
                }
                else {
                    $("#lblMsg").text('Type Already Added');
                    $("#ddlType").focus();
                    return;
                }
            }
            else {
                $("#lblMsg").text('Please Select Type');
                $("#ddlType").focus();
                return;
            }
        }
        function bindUniversalFormat() {
            $.ajax({
                url: "UserManager_New.aspx/bindUniversalFormat",
                data: '',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    data = jQuery.parseJSON(mydata.d);
                    if (data != null) {
                        var output = $('#tb_id_master_format').parseTemplate(data);
                        $('#id_master').html(output);
                    }
                    else {

                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        function showUniversalFormat() {
            bindUniversalFormat();
            $find("mpopUnFormat").show();
        }
        function checkStore() {
            if ($("#rbtnStore input[type=radio]:checked").val() == "1") {
                $("#trcheckRight,#lblRightsFor,#chkMed,#chkGen").show();
            }
            else {
                $("#trcheckRight,#lblRightsFor,#chkMed,#chkGen").hide();
            }
            $("#chkMed,#chkGen").attr('checked', false);
        }
    </script>
    <asp:Panel ID="pnlUniversialFormat" runat="server" CssClass="pnlFilter"  Style="display: none;width:760px">
        <div style="text-align:center;width:100%">
            <table style="width:100%">
                <tr>
                    <td style="text-align: center" colspan="2">
                        <div id="id_master"></div>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center" colspan="2">
                        <asp:Button ID="btnCancelUnFormat" runat="server" CssClass="ItDoseButton" Text="Cancel" />
                        </td>
                </tr>
            </table>
         
      
            </div>
    </asp:Panel>
    <script type="text/javascript">
        function format() {
            var dataFormat = new Array();
            var Obj = new Object();
            $("#tbSelected tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "formatHeader") {
                    Obj.TypeName = $.trim($rowid.find("#spnTypeName").text());
                    Obj.formatID = $.trim($rowid.find("#spnTypeID").text());
                    Obj.InitialCharacter = $.trim($rowid.find("#spnInitialCharacter").text());
                    if ($.trim($rowid.find("#spnFinYear").text()) != "") {
                        Obj.FinYear = $.trim($rowid.find("#spnFinYear").text());
                        Obj.chkFinancialYear = "1";
                    }
                    else {
                        Obj.FinYear = "0001-01-01";
                        Obj.chkFinancialYear = "0";
                    }
                    Obj.Separator1 = $.trim($rowid.find("#spnSeparator1").text());
                    Obj.Separator2 = $.trim($rowid.find("#spnSeparator2").text());
                    Obj.Length = $.trim($rowid.find("#spnLength").text());
                    Obj.TextLength = $.trim($rowid.find("#spnTextLength").text());
                    Obj.FormatPreview = $.trim($rowid.find("#spnlPreview").text());
                    Obj.IsUniversalType = $.trim($rowid.find("#spnIsUniversalType").text());
                    dataFormat.push(Obj);
                    Obj = new Object();
                }

            });
            return dataFormat;
        }
        function saveRole() {
            $("#btnSaveRole").attr('disabled', 'disabled');
            if ($.trim($("#txtRole").val()) == "") {
                $("#lblMsg").text('Please Enter Role Name');
                $("#txtRole").focus();
                $("#btnSaveRole").removeAttr('disabled');
                return false;
            }
            //$("#ddlType  option").each(function () {
            //    $('#tbSelected tr:not(#formatHeader)').each(function () {
            //        if ($(this).val() == $.trim($(this).closest("tr").find("#spnTypeID").text())) {

            //        }
            //    });
               
            //});
            
            if ((parseFloat($("#ddlType  option").length - 1) != parseFloat($('#tbSelected tr:not(#formatHeader)').length)) && (($("#rblIsUniversal input[type=radio]:checked").val())=="0")) {
                $("#lblMsg").text('Please Add All Type');
                $("#ddlType").focus();
                $("#btnSaveRole").removeAttr('disabled');
                return false;
            }
            
            var data = new Array();
            var Obj = new Object();

            Obj.RoleName = $('#txtRole').val();
            Obj.IsDepartment = $("#rblIsDepartment input[type=radio]:checked").val();
            Obj.IsUniversal = $("#rblIsUniversal input[type=radio]:checked").val();
            Obj.menuFor = $('#ddlDeptMenu').val();
            Obj.menuForText = $('#ddlDeptMenu option:selected').text();
            Obj.IsStore = $("#rbtnStore input[type=radio]:checked").val();
            Obj.IsGeneral = $('#chkGen').is(':checked') ? 1 : 0;
            Obj.IsMedical = $('#chkMed').is(':checked') ? 1 : 0;
            data.push(Obj);

            var formatData = format();
            $.ajax({
                url: "UserManager_New.aspx/saveRole",
                data: JSON.stringify({ roleDetail: data, FormatDetail: formatData }),
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    if (mydata.d.length == "1") {
                        data = mydata.d;
                        if (data == "1") {
                            alert("Record Save Successfully");
                            clearAllData();
                        }
                        else if (data == "2") {
                            alert("Role Name Already Added");

                        }
                        else if (data == "3") {
                            alert("Universal Format Not Found");

                        }
                        else {
                            alert("Error");

                        }
                    }
                    else {
                        data = jQuery.parseJSON(mydata.d);
                        for (i = 0; i < data.length; i++) {
                            var titleText = data[i].InitialCharacter + ' Initial Character Already Added ';
                            $('#tbSelected tbody tr:eq(' + data[i].Id + ') td').css("background-color", "#FF0000");
                            $('#tbSelected tbody tr:eq(' + data[i].Id + ') td').attr('title', titleText);
                        }
                        jQuery("#lblMsg").text('');
                    }

                    $("#btnSaveRole").removeAttr('disabled');
                }
            });
            $('#btnSaveFromat').removeAttr('disabled');
        }
        function clearAllData() {
            $("#ddlType,#ddlSeparator1,#ddlSeparator2,#ddlLength,#ddlDeptMenu,#ddlRole1").prop('selectedIndex', '0');
            $("#txtInitial,#txtFinYear,#txtRole").val('').removeAttr('disabled');
            $("#lblPreview").text('');
            $("#txtFinYear").attr('disabled', 'disabled');
            $("#tbSelected tr:not(#formatHeader)").remove();
            $('#tbSelected').removeAttr('disabled').hide();
            $('#chkGen,#chkMed,#chkFinYear,#chkIsUniversal').attr('checked', false).removeAttr('disabled');
            $('#lblRightsFor,#trIsUniversal,#ddlRole1,#trcheckRight,#trFormat').hide();

            $('#rblIsDepartment').find("input[value='0']").attr("checked", "checked");
            $('#rblIsUniversal').find("input[value='1']").attr("checked", "checked");
            $('#rbtnStore').find("input[value='0']").attr("checked", "checked");
            $("#btnSaveRole,#ddlSeparator1,#ddlSeparator2,#ddlLength").removeAttr('disabled');
            
        }

        function updateRole() {
            if ($("#ddlRole1 option:selected").text() == "Select") {
                $("#lblMsg").text('Please Select Role');
                $("#ddlRole1").focus();
                return false;
            }
            $.ajax({
                url: "UserManager_New.aspx/saveRole",
                data: JSON.stringify({ roleDetail: data, FormatDetail: formatData }),
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                }

            });
        }
    </script>
    <script type="text/javascript">
        function editRole() {
            clearAllData();
            $("#pnlRole,#btnUpdateRole,#btnCancelRole").show();
            $("#txtRole,#btnSaveRole ").hide();
            $("#ddlRole1,#ddlDeptMenu").prop('selectedIndex', '0').show();
            
        }
        function cancelRole() {
            clearAllData();
            $("#ddlRole1").show();
            $("#txtRole").hide();
        }
    </script>
        <script id="tb_id_master_format" type="text/html">
    <table  id="id_master_format"  cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse; ">
        <thead>
		<tr id="Header">
             
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;text-align:left">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:left">Initial Character</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;text-align:center">Separator1</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px; text-align:left">Financial Year Start</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px; text-align:center">Separator2</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px; text-align:left">Length</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;text-align:left">Preview</th>
		</tr>
            </thead>
        <tbody>
            <#                
        for(var j=0;j<data.length;j++)
        {       
       var objRow = data[j];
        #>
                        <tr>
                        
                        <td  class="GridViewLabItemStyle" style="width:140px;text-align:left"><#=objRow.TypeName#></td>
                        <td class="GridViewLabItemStyle" style="width:80px;text-align:left"><#=objRow.InitialChar#></td>
                        <td class="GridViewLabItemStyle" style="width:40px;text-align:center"><#=objRow.Separator1#></td>
                        <td class="GridViewLabItemStyle" style="width:120px;text-align:left"><#=objRow.FinancialYearStart#></td>
                        <td class="GridViewLabItemStyle" style="width:40px;text-align:center"><#=objRow.Separator2#></td>
                        <td class="GridViewLabItemStyle" style="width:20px;text-align:left"><#=objRow.TypeLength#></td>
                        <td class="GridViewLabItemStyle" style="width:180px;text-align:left"><#=objRow.FormatPreview#></td>   
                              </tr>            
        <#}        
        #>
            </tbody>      
     </table>  
    
    </script>

</asp:Content>

