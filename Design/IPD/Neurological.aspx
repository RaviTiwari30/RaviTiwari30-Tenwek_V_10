<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Neurological.aspx.cs" Inherits="Design_CPOE_Neurological" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/PhysioHeader.ascx" TagPrefix="Phy" TagName="PhysioHeader" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script type="text/javascript">
        function validate(btn) {
            $("#btnSave").val('Submitting...').attr('disabled', 'disabled');
            __doPostBack('btnSave', '');

            return true;
        }

        function printDiv() {
            var oldPage = document.body.innerHTML;
            $(".PhysioHeader").show();
            $(".noprint").hide();
            $("#<%=btnPrint.ClientID %>").hide();
            $("#<%=lblMsg.ClientID %>").hide();
            $("#<%=btnSave.ClientID %>").hide();
            window.print();
            document.body.innerHTML = oldPage;
        }

        function refresh() {
            $("input[type=text], textarea").val("");
            $(':radio').removeProp('checked');
        }
    </script>

    <form id="form1" runat="server">
        <ajax:ScriptManager ID="ScriptManager1" runat="server"></ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div style="text-align: center">
                    <div style="text-align: center">
                        <b>Neurological Exam</b>
                    </div>
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <asp:Panel ID="pnlGrid" runat="server" Height="100px" Width="100%" ScrollBars="Auto" Visible="false">
                    <asp:GridView ID="grdNeu" runat="server" AutoGenerateColumns="false" Width="100%" OnRowCommand="grdNeu_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Neurological Exam">
                                <ItemTemplate>
                                    <asp:Label ID="lblNeurologicalExam" runat="server" Text='<%#Eval("IsNeurologicalExam") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Entry By">
                                <ItemTemplate>
                                    <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("EntryBy") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Entry Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("EntryDate") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="View & Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:Button runat="server" ID="imbView" CausesValidation="false" CommandName="AView" Text="View & Edit" ToolTip="Click To View & Edit" CommandArgument='<%# Eval("ID")  %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
            <div id="Div1" class="PhysioHeader" style="display: none;">
                <Phy:PhysioHeader ID="Physio" runat="server" />
                <asp:Label ID="lblTransactionID" runat="server" Style="display: none;"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <table width="100%">
                    <tr>
                        <td style="vertical-align: top; text-align: right; text-align: left;">
                            <asp:Label ID="lblAppdate" runat="server" Style="font-weight: 700; color: #003399"></asp:Label>
                        </td>
                        <td style="text-align: left;">
                            <asp:Label ID="lblDocName" runat="server" Style="font-weight: 700; color: #003399"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 50%; text-align: left; margin-top: 0;">
                            <table style="width: 100%" border="1">
                                <tr>
                                    <td colspan="3" style="text-align: center; width: 100%;">
                                        <b>Neurological Exam</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="text-align: left; width: 100%;">
                                        <asp:RadioButtonList ID="chkNeurologicalExam" runat="server" RepeatColumns="2" RepeatDirection="Horizontal">
                                            <asp:ListItem Text="Normal (If normal, skip)" Value="Normal"></asp:ListItem>
                                            <asp:ListItem Text="Abnormal" Value="Abnormal"></asp:ListItem>
                                            <asp:ListItem Text="Complete ASIA" Value="CASIA"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                            </table>
                            <table id="tbtNeuro" style="width: 100%" border="1">
                                <tr>
                                    <td style="text-align: left; font-weight: 700;">Muscle (5-<strong>1</strong>)</td>
                                    <td style="text-align: center; width: 25%;">
                                        <strong>Right</strong>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <strong>Left</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">Bicep C5</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleR1" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleL1" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">Wrist Extensor C6
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleR2" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleL2" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">Tricep C7</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleR3" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleL3" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">Finger Flexors C8
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleR4" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleL4" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">Interossei T1
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleR5" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleL5" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">iliopsoas L2
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleR6" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleL6" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">Quadriceps L3</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleR7" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleL7" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">Tibialis Anterior L4</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleR8" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleL8" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">Extensor Hallucis L5</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleR9" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleL9" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">Gastrocsoleus S1</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleR10" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtMuscleL10" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="text-align: left; width: 100%;">
                                        <strong>Sacral Roots</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">Perianal Sensation:</td>
                                    <td colspan="2" style="text-align: left; width: 50%;">
                                        <asp:RadioButtonList ID="chkSacralRoot" runat="server" RepeatDirection="Horizontal" Width="125px">
                                            <asp:ListItem>2</asp:ListItem>
                                            <asp:ListItem>1</asp:ListItem>
                                            <asp:ListItem>0</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">Rectal:</td>
                                    <td colspan="2" style="text-align: left; width: 50%;">
                                        <asp:RadioButtonList ID="chkSacralRootrectal" runat="server" RepeatDirection="Horizontal" RepeatColumns="2">
                                            <asp:ListItem>Intact</asp:ListItem>
                                            <asp:ListItem>Decreased</asp:ListItem>
                                            <asp:ListItem>Absent</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; vertical-align: top;">
                                        <strong>Note / Remark :</strong>
                                    </td>
                                    <td colspan="2" style="text-align: left; width: 50%;">
                                        <asp:TextBox ID="txtNote" runat="server" Height="75px" Width="330px" MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 50%; text-align: left; margin-top: 0;">
                            <table style="width: 100%" border="1">
                                <tr>
                                    <td style="text-align: left; width: 50%; font-weight: 700;">Dermatone (2-0)</td>
                                    <td style="text-align: center; width: 25%;">
                                        <strong>Right</strong>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <strong>Left</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Midclavicular C4</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR1" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL1" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Lateral Epicondyle C5</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR2" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL2" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Dorsum Thumb C6</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR3" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL3" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Long Finger C7</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR4" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL4" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Small Finger C8
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR5" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL5" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Medial Epicondyle T1</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR6" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL6" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Midthigh Midline L2</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR7" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL7" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Medial Knee L3</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR8" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL8" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Medial Malleolus L4</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR9" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL9" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">1st Dorsal Webspace L5</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR10" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL10" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Lateral Foot S1</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR11" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL11" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Popliteal Space S2</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneR12" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="txtDermatoneL12" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                            <table style="width: 100%" border="1">
                                <tr>
                                    <td style="text-align: left; width: 50%; font-weight: 700;">Reflexes (+ - +++)</td>
                                    <td style="text-align: center; width: 25%;">
                                        <strong>Right</strong>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <strong>Left</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Biceps</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="chkReflexesR1" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="chkReflexesL1" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Triceps</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="chkReflexesR2" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="chkReflexesL2" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Quadriceps</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="chkReflexesR3" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="chkReflexesL3" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Achilles</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="chkReflexesR4" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:TextBox ID="chkReflexesL4" runat="server" CssClass="ItDoseTextinputNum" Height="16px" Width="50px" MaxLength="5"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%; font-weight: 700;">Ankle Clonus</td>
                                    <td colspan="2" style="text-align: center; width: 50%;">
                                        <asp:RadioButtonList ID="chkAncleclonus" runat="server" RepeatDirection="Horizontal" RepeatColumns="2">
                                            <asp:ListItem>Yes</asp:ListItem>
                                            <asp:ListItem>No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Several beats</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:RadioButtonList ID="chkAnkleClonusR1" runat="server" RepeatDirection="Horizontal" RepeatColumns="2">
                                            <asp:ListItem>Y</asp:ListItem>
                                            <asp:ListItem Value="N">N</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:RadioButtonList ID="chkAnkleClonusL1" runat="server" RepeatDirection="Horizontal" RepeatColumns="2">
                                            <asp:ListItem>Y</asp:ListItem>
                                            <asp:ListItem Value="N">N</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; width: 50%;">Sustained</td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:RadioButtonList ID="chkAnkleClonusR2" runat="server" RepeatDirection="Horizontal" RepeatColumns="2">
                                            <asp:ListItem>Y</asp:ListItem>
                                            <asp:ListItem>N</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                    <td style="text-align: center; width: 25%;">
                                        <asp:RadioButtonList ID="chkAnkleClonusL2" runat="server" RepeatDirection="Horizontal" RepeatColumns="2">
                                            <asp:ListItem>Y</asp:ListItem>
                                            <asp:ListItem>N</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" ClientIDMode="Static" OnClick="btnSave_Click" OnClientClick="return validate(this);" />
                    <asp:Button ID="btnPrint" Text="Print" CssClass="ItDoseButton" runat="server" class="noprint" Visible="false" OnClientClick="printDiv()" />
                    <asp:Button ID="btnCancel" Text="Cancel" CssClass="ItDoseButton" runat="server" class="noprint" OnClick="btnCancel_Click" OnClientClick="refresh();" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
