<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPD_ECGExamination.aspx.cs" Inherits="Design_IPD_IPD_ECGExamination" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>REQUEST FOR DOPPLER ECHOCARDIOGRAPHY(ECG) EXAMINATION </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    REASON FOR REQUESTING DOPPLER ECHOEXAMINATION
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: right; width: 35%;">Cardiomegaly of Unknown Cause :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtCardiomegalyCause" TabIndex="1" runat="server" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;"></td>
                        <td style="text-align: left; width: 38%;"></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">Heart Failure of Unknown Cause :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtHeartFailure" runat="server" TabIndex="2" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;"></td>
                        <td style="text-align: left; width: 38%;"></td>
                    </tr>
                    <tr></tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">Systolic Murmur (State site(s)):&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtSystolic" runat="server" TabIndex="3" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">Diastolic Murmur (State site(s)):&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txtDiastolic" runat="server" TabIndex="4" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">Rheumatic Cardits/Fever/Heart Disease(State Lesions) :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtRheumatic" runat="server" TabIndex="5" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;"></td>
                        <td style="text-align: left; width: 38%;"></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">Fever :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtFever" runat="server" TabIndex="6" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">Clubbing of Fingers :&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txtClubbing" runat="server" TabIndex="7" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%">Splenomegaly :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtSplenomegaly" runat="server" TabIndex="8" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">MicroScopic/microscopic Haematuria :&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txtMicroHaematuria" runat="server" TabIndex="9" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%">Positive Blood Culture (Organism) :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtPBlood" runat="server" TabIndex="10" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;"></td>
                        <td style="text-align: left; width: 38%;"></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%">Raised ESR :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtRaisedESR" runat="server" TabIndex="11" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">Anaemia :&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txtAnaemia" runat="server" TabIndex="12" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%">Pericardial Effusion/Cardiac Tamponade/Pericarditis :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtPeriCardial" runat="server" TabIndex="13" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">Hypertensive Heart Disease :&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txtHypertens" runat="server" TabIndex="14" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%">Angina Pectoris/Myocardial Infarction :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtAngina" runat="server" TabIndex="15" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">Confenital Heart Disease :&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txtConfenital" runat="server" TabIndex="16" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">Other Reason :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtOReason" runat="server" TabIndex="17" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;"></td>
                        <td style="text-align: left; width: 38%;"></td>
                    </tr>
                    <tr></tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    CLINICAL SUMMARY
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: right; width: 35%;">Dyspnoea :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtDyspnoea" runat="server" TabIndex="18" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">Easy Fatigability :&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txtEFatigability" runat="server" TabIndex="19" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">Palpitation :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtPalpitation" runat="server" TabIndex="20" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">Orthoponoea :&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txtOrthoponoea" runat="server" TabIndex="21" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">Nocturnal Dyspnoea/Wheezing/Coughing :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtNocturnal" runat="server" TabIndex="22" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;"></td>
                        <td style="text-align: left; width: 38%;"></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">Forthy Sputum :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtForthySputum" runat="server" TabIndex="23" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">Haemoptysis :&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txtHaemoptysis" runat="server" TabIndex="24" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">Ankle/Abdominal/Generalised Swelling :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtAnkle" runat="server" TabIndex="25" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;"></td>
                        <td style="text-align: left; width: 38%;"></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">New York Assosiation Functional Class :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txtNYAssosiation" runat="server" TabIndex="26" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;"></td>
                        <td style="text-align: left; width: 38%;"></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">1 :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txt_1" runat="server" TabIndex="27" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">2 :&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txt_2" runat="server" TabIndex="28" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 35%;">3 :&nbsp;</td>
                        <td style="text-align: left; width: 15%;">
                            <asp:TextBox ID="txt_3" runat="server" TabIndex="29" Width="150px"></asp:TextBox>
                        </td>
                        <td style="text-align: right; width: 22%;">4 :&nbsp;</td>
                        <td style="text-align: left; width: 38%;">
                            <asp:TextBox ID="txt_4" runat="server" TabIndex="30" Width="150px"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" Text="Save" title="Click to Save" TabIndex="31" class="ItDoseButton" OnClick="btnsave_Click" />
                <asp:Button ID="btnUdate" runat="server" Text="Update" title="Click to Update" TabIndex="31" class="ItDoseButton" OnClick="btnUdate_Click" Visible="false" />
            </div>
            <div class="POuter_Box_Inventory" style="overflow-x: scroll;">
                <asp:GridView ID="grdDataView" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" OnRowCommand="grdDataView_rowCaommand">
                    <Columns>
                        <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="Edit1" ImageUrl="~/Images/edit.png" CommandArgument='<%# Eval("ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Print" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandName="Print" ImageUrl="~/Images/Print.gif" CommandArgument='<%# Eval("ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CardiomegalyofUCouse" HeaderText="CardiomegalyUC">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="HeartfailureofUCause" HeaderText="HeartFailureUC">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="SystolicmurmurState" HeaderText="SMurmur">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="DiastolicmurmurState" HeaderText="DMurmur ">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="RCarditisFeverHeDisease" HeaderText="RheumaticCardits">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Fever" HeaderText="Fever">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Clubblingoffing" HeaderText="ClubbingFingers">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Splenmegaly" HeaderText="Splenomegaly">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="MicroHeamaturia" HeaderText="micro-Haematuria">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PoBloodCulture" HeaderText="PoBlood">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="RaisedEsr" HeaderText="RaisedESR">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Anaemia" HeaderText="Anaemia">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PeriEffCardTampPeri" HeaderText="PericardialEff">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="HyperHeartDis" HeaderText="Hyper-Heart">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="AngPectMyoCardinf" HeaderText="AnginaPectoris">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="CongHeartDis" HeaderText="Conf-Heart">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="OtherRes" HeaderText="Oth-Reason">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Dyspnoea" HeaderText="Dyspnoea">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="EasyFatig" HeaderText="EasyFatigability">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Palpitation" HeaderText="Palpitation">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Orthopoea" HeaderText="Orthoponoea">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="NoctDypWheeCough" HeaderText="Noc-Dyspnoea">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FrothySputum" HeaderText="ForthySputum">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Heamoptysis" HeaderText="Haemoptysis">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="AnkleAbdoGenSwel" HeaderText="Ankle/Abd">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="NYHeartAssFuncClass" HeaderText="NYAssosiation">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="NYHeartAssFuncClass_1" HeaderText="1">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="NYHeartAssFuncClass_2" HeaderText="2">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="NYHeartAssFuncClass_3" HeaderText="3">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="NYHeartAssFuncClass_4" HeaderText="4">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="lastUpdatedBy" HeaderText="UpadatedBy">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="lastUpdatedate" HeaderText="UpdateDate">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
