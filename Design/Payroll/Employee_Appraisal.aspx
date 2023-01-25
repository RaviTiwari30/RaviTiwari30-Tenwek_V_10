<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Employee_Appraisal.aspx.cs"
    MaintainScrollPositionOnPostback="true" MasterPageFile="~/DefaultHome.master"
    Inherits="Design_Payroll_Employee_Appraisal" EnableViewState="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript"  src="../../Scripts/MaxLength.min.js"></script>
    <script type="text/javascript">
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpEmployeeSelection")) {
                    $find("mpEmployeeSelection").hide();

                }
                if ($find("mpAppraisalQ")) {
                    $find("mpAppraisalQ").hide();

                }
            }
        }
    </script>
    <script type="text/javascript">

        //        $(document).ready(function () {
        //            var grdValue = $('#<%=GvQuestion.ClientID %>').find('input:textarea');
        //            $('input[id$=txtAnswer]').bind("keyup keypress", function (e) {
        //                var maxLength = 10;
        //                var textlength = this.value.length;
        //                if (textlength >= maxLength) {
        //                    alert(textlength);
        //                    this.value = this.value.substring(0, maxLength);
        //                    e.preventDefault();

        //                }

        //                else {
        //
        //                }
        //            });
        //        });
        $(document).ready(function () {

            $("[id*=txtComment]").MaxLength(
            {
                MaxLength: 100,
                DisplayCharacterCount: false
            });

        });
        function textMaxLength(obj, maxLength, evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            var max = maxLength - 0;
            var text = obj.value;
            if (text.length > max) {
                var ignoreKeys = [8, 46, 37, 38, 39, 40, 35, 36];
                for (i = 0; i < ignoreKeys.length; i++) {
                    if (charCode == ignoreKeys[i]) {
                        return true;
                    }
                }
                return false;
            } else {
                return true;
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=btnSave.ClientID %>").click(function () {
                var flag = true;
                $("table[id*=GvQuestion] textarea.secondTxt").each(function (i, itm) {
                    if ($(itm).val() == "") {
                        $("#<%=lblmsgpopup.ClientID %>").text('Please Enter Answer');
                        flag = false;
                    }
                });
                if (!flag) {
                    return false;
                }
            });
            $('[id$=GvQuestion] input[type=radio]')

        });
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Appraisal</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table border="0" id="tbl1" runat="server" style="width: 100%">
                <tr>
                    <td style="width: 21%; height: 11px;" align="right">Employee ID :&nbsp;
                    </td>
                    <td style="width: 18%; height: 11px;">
                        <asp:TextBox ID="txtEmployeeID" runat="server" MaxLength="20" TabIndex="1" ToolTip="Enter Employee ID"></asp:TextBox>
                    </td>
                    <td style="width: 20%; height: 11px;" align="right">Employee Name :&nbsp;
                    </td>
                    <td style="width: 20%; height: 11px;">
                        <asp:TextBox ID="txtEmployeeName" runat="server" MaxLength="50" TabIndex="2" ToolTip="Enter Employee Name"></asp:TextBox>
                    </td>
                    <td style="width: 25%; height: 11px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%; height: 6px;" align="right"></td>
                    <td style="width: 18%; height: 6px;"></td>
                    <td style="width: 20%; height: 6px;" align="right"></td>
                    <td style="width: 20%; height: 6px;">
                        <asp:Label ID="lblAppraisalID" runat="Server" Visible="False"></asp:Label>
                    </td>
                    <td style="width: 25%; height: 6px;"></td>
                </tr>
                <tr>
                    <td align="right" style="width: 21%; height: 6px"></td>
                    <td style="width: 18%; height: 6px"></td>
                    <td align="center" style="width: 20%; height: 6px">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                            CssClass="ItDoseButton" TabIndex="3" ToolTip="Click to Search" />
                    </td>
                    <td style="width: 20%; height: 6px"></td>
                    <td style="width: 25%; height: 6px"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5">
                        <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="EmpGrid_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Employee_ID" HeaderText="Employee&nbsp;ID" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="260px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="FatherName" HeaderText="Father Name" Visible="false" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Gender" HeaderText="Sex" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DOJ" HeaderText="D.O.J." ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Select">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbSelect" ToolTip="Click to Select" runat="server" ImageUrl="~/Images/Post.gif"
                                            CausesValidation="false" CommandArgument='<%# Eval("Employee_ID")%>' CommandName="Select" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
            <cc1:ModalPopupExtender ID="mpEmployeeSelection" runat="server" BackgroundCssClass="filterPupupBackground"
                CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlUpdate" PopupDragHandleControlID="dragHandle"
                TargetControlID="btnHidden" BehaviorID="mpEmployeeSelection">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none">
                <div id="dragUpdate" runat="server" class="Purchaseheader">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 590px">
                        <tr>
                            <td style="height: 16px">
                                <b>Appraisal</b>&nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
                                &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
                                &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                                &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <em ><span style="font-size: 7.5pt">  Press esc to close</span></em>
                            </td>
                        </tr>
                    </table>
                </div>
                <table border="0" width="590px" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="right" style="width: 230px">&nbsp;&nbsp;I am providing ratings for :&nbsp;
                        </td>
                        <td style="width: 19px"></td>
                        <td align="left">
                            <asp:DropDownList ID="ddlEmployeeName" runat="server" TabIndex="4" ToolTip="Select Employee Name"
                                Width="290px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 230px">
                            <br />
                        </td>
                        <td style="width: 19px"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 230px">&nbsp;&nbsp;My relation to the ratee is :&nbsp;
                        </td>
                        <td style="width: 19px"></td>
                        <td align="left">
                            <asp:DropDownList ID="ddlAppraisalType" runat="server" TabIndex="5" ToolTip="Select Relation">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 191px">
                            <br />
                        </td>
                        <td style="width: 19px"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="width: 191px"></td>
                        <td style="width: 19px"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="width: 230px" align="right">
                            <asp:Button ID="btnClose" CssClass="ItDoseButton" runat="server" Text="Close" TabIndex="7"
                                ToolTip="Click to Close" />
                        </td>
                        <td style="width: 19px"></td>
                        <td>
                            <asp:Button ID="btnNext" runat="server" Text="Next" OnClick="btnNext_Click" TabIndex="6"
                                ToolTip="Click to Next" CssClass="ItDoseButton" />
                        </td>
                    </tr>
                </table>
                <br />
            </asp:Panel>
            <div style="display: none">
                <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton"/>
            </div>
        </div>
        <cc1:ModalPopupExtender ID="mpAppraisalQ" runat="server" BackgroundCssClass="filterPupupBackground"
            CancelControlID="btnAppraisalClose" DropShadow="true" PopupControlID="pnlAppraisal"
            PopupDragHandleControlID="dragHandle" TargetControlID="btnHidden" BehaviorID="mpAppraisalQ">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="pnlAppraisal" ScrollBars="Vertical" Height="550px" Width="878px" runat="server"
            CssClass="pnlOrderItemsFilter" Style="display: none;">
            <div class="Purchaseheader">
                &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
                &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
                &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
                &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
                &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
                &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Press esc to close
            </div>
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="height: 16px;" align="center" colspan="4">
                        <asp:Label ID="lblmsgpopup" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="6">
                        <asp:GridView ID="GvQuestion" Width="94%" runat="server" AutoGenerateColumns="False"
                            CssClass="GridViewStyle" OnRowDataBound="GvQuestion_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <%-- <th>S.No</th>
                                    <th>Question</th>
                                    <th>Answer</th>--%>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <table width="100%">
                                            <tr>
                                                <td colspan="5" class="GridViewHeaderStyle">
                                                    <asp:Label ID="lblGroupHeader" Width="100%" runat="server" Visible="true" Text='<%#Eval("GroupHeader") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 4%" valign="top">
                                                    <%# Container.DataItemIndex+1 %>.
                                                    <asp:Label ID="lblQuestion_ID" runat="server" Visible="False" Text='<%#Eval("Question_ID") %>'></asp:Label>
                                                </td>
                                                <td align="left" valign="top" style="width: 50%">
                                                    <%#Eval("Question") %>
                                                </td>
                                                <td align="left" valign="top" style="width: 56%">
                                                    <asp:Label ID="lblAnswer_Type" runat="server" Visible="False" Text='<%#Eval("Answer_Type") %>'></asp:Label>
                                                    <asp:TextBox ID="txtAnswer" Width="380px" runat="server" Visible="false" TextMode="multiLine"
                                                        CssClass="secondTxt" MaxLength="10" onpaste="return false;" onKeyPress="return textMaxLength(this, '100', event);"></asp:TextBox>
                                                    <asp:RadioButtonList ID="rbtnAnswer" RepeatDirection="Horizontal" runat="server"
                                                        Visible="false" CssClass="secondRadio">
                                                    </asp:RadioButtonList>
                                                </td>
                                                <td style="width: 5%" align="left">
                                                    <asp:RequiredFieldValidator ID="AnswerText" runat="server" ControlToValidate="txtAnswer"
                                                        SetFocusOnError="true" ValidationGroup="save" Display="None" />
                                                    <asp:RequiredFieldValidator ID="AnswerRbtn" Display="Dynamic" runat="server" ControlToValidate="rbtnAnswer"
                                                        SetFocusOnError="true" ValidationGroup="save" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                    </FooterTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2" align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Comment&nbsp;if&nbsp;Any :&nbsp;
                    </td>
                    <td align="left" colspan="4" style="height: 6px">
                        <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Width="662px" onpaste="return false;"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="left" colspan="5" style="height: 6px">
                        <asp:Label ID="lblEmployeeID" Visible="false" runat="server" Font-Bold="True">
                        </asp:Label>
                    </td>
                    <td align="left" colspan="1" style="height: 6px; width: 16416px;">
                        <asp:Label ID="lblAppraisalEntryEmployeeID" Visible="False" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="6" style="height: 8px">
                        <asp:Button ID="btnSave" ValidationGroup="save" runat="server" Text="Save" OnClick="btnSave_Click"
                            ToolTip="Click to Save" CssClass="ItDoseButton" />&nbsp;
                        <asp:Button ID="btnAppraisalClose" runat="server" CssClass="ItDoseButton" Text="Close"
                            ToolTip="Click to Close" />
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="7"></td>
                </tr>
            </table>
        </asp:Panel>
    </div>
</asp:Content>