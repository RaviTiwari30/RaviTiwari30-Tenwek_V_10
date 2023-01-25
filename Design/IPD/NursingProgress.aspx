<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NursingProgress.aspx.cs" Inherits="Design_IPD_NursingProgress" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/Message.js" type="text/javascript"></script>

    <script type="text/javascript">
        if ($.browser.msie) {
            $(document).on("keydown", function (e) {
                var doPrevent;
                if (e.keyCode == 8) {
                    var d = e.srcElement || e.target;
                    if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                        doPrevent = d.readOnly
                            || d.disabled;
                    }
                    else
                        doPrevent = true;
                }
                else
                    doPrevent = false;
                if (doPrevent) {
                    e.preventDefault();
                }
            });
        }
    </script>
    <style type="text/css">
        .auto-style1 {
            width: 189px;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <script type="text/javascript">
            $(document).ready(function () {

            });

            function note(e,type) {
			   e.preventDefault();
                if ($.trim($("#<%=txtProblems.ClientID%>").val()) == "") {
                     $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Problems');
                     $("#<%=txtProblems.ClientID%>").focus();
                     return false;
                 }
                 if ($.trim($("#<%=txtPrescription.ClientID%>").val()) == "") {
                     $("#<%=lblMsg.ClientID%>").text('Please Enter Prescription And Implementation');
                     $("#<%=txtPrescription.ClientID%>").focus();
                     return false;
                 }
                 if ($.trim($("#<%=txtEvaluation.ClientID%>").val()) == "") {
                     $("#<%=lblMsg.ClientID%>").text('Please Enter Evaluation');
                     $("#<%=txtEvaluation.ClientID%>").focus();
                     return false;
                 }
				 if (type == 'Save') {
                    document.getElementById('<%=Btnsave.ClientID%>').disabled = true;
                    document.getElementById('<%=Btnsave.ClientID%>').value = 'Submitting...';
                    __doPostBack('Btnsave', '');
                }
                else {
                    document.getElementById('<%=btnUpdate .ClientID%>').disabled = true;
                    document.getElementById('<%=btnUpdate.ClientID%>').value = 'Submitting...';
                    __doPostBack('btnUpdate', '');
                }
             }
        </script>
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Nursing Care Plan and Progress </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Nursing Care Plan and Progress
                </div>
                <div class="row">
                    <div class="col-md-24">
                        &nbsp; Date / Time :&nbsp;

                        <asp:TextBox ID="txtDate" runat="server"
                                ToolTip="Click To Select Date" Width="100px" TabIndex="1"
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                            <asp:TextBox ID="txtTime" TabIndex="12" runat="server" Width="100px"    ClientIDMode="Static" ></asp:TextBox>
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTimeStart" runat="server" ControlToValidate="txtTime" ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time" InvalidValueMessage="Invalid Time ON" ForeColor="Red" Display="None"></cc1:MaskedEditValidator>
                        
                    </div>
                    </div>
                <div class="row">
                    <div class="col-md-3">
                        Goal/Object :&nbsp;

                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtProblems"  CssClass="notrequiredField"  runat="server" TextMode="MultiLine" TabIndex="2" Style="width: 500px; Height: 70px" MaxLength="1000"></asp:TextBox>
                            <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">(Max 1000 Char.)</asp:Label>
                        
                        </div>
                    
                    <div class="col-md-3">
                        Implementation :&nbsp;

                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtImplementation"  CssClass="notrequiredField"  runat="server" TextMode="MultiLine" TabIndex="5" Style="width: 500px; Height: 70px" MaxLength="1000"></asp:TextBox>
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">(Max 1000 Char.)</asp:Label>
                        
                    </div>
                    </div>
                
                <div class="row">
                    <div class="col-md-3">
                        Nursing Intervention/
                            <br />
                            Management Plan :&nbsp;

                    </div>
                    <div class="col-md-5">
                         <asp:TextBox ID="txtPrescription" CssClass="notrequiredField"  runat="server" TextMode="MultiLine" TabIndex="3" Height="70px" Width="500px" MaxLength="1000"></asp:TextBox>
                            <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">(Max 1000 Char.)</asp:Label>
                        
                        </div>
                    
                    <div class="col-md-3">Evaluation/Outcome :&nbsp;

                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtEvaluationOutcome"  CssClass="notrequiredField"  runat="server" TextMode="MultiLine" TabIndex="6" Style="width: 500px; Height: 70px" MaxLength="1000"></asp:TextBox>    
                            <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">(Max 1000 Char.)</asp:Label>
                        
                        </div>
                    </div>
                
                <div class="row">
                    <div class="col-md-3">Rationale :&nbsp;

                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtEvaluation"  CssClass="notrequiredField"  runat="server" Height="65px" TextMode="MultiLine" TabIndex="4" Style="width: 500px; Height: 70px" MaxLength="1000"></asp:TextBox>
                            <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;">(Max 1000 Char.)</asp:Label>
                        
                        </div>
                    
                    <div class="col-md-3">Active Evaluated :&nbsp;

                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtActiveEvaluated" CssClass="notrequiredField"  runat="server" TextMode="MultiLine" TabIndex="7" Style="width: 500px; Height: 70px" MaxLength="1000"></asp:TextBox>
                            <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;">(Max 1000 Char.)</asp:Label>
                        </div>
                    </div>
                
                <div class="row">
                    <div class="col-md-3">Nursing Diagnosis :&nbsp;

                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtNursingDiagnosis" CssClass="notrequiredField" runat="server" Height="65px" TextMode="MultiLine" TabIndex="8" Style="width: 500px; Height: 50px" MaxLength="1000"></asp:TextBox>
                           <%-- <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;">(Max 1000 Char.)</asp:Label>--%>
                        
                        </div>
                    </div>
                <div class="row">
                    <div class="col-md-24">
                        <asp:Label ID="lblID" runat="server" Visible="FALSE"></asp:Label>

                    </div>
                    </div>
                </div>

            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                
                <%--<asp:Button ID="Btnsave" runat="server" OnClick="btnSave_Click" Text="save" TabIndex="9" CssClass="ItDoseButton" OnClientClick="return note(event,'Save')" />
                --%><asp:Button ID="Btnsave" runat="server" OnClick="btnSave_Click" Text="save" CausesValidation="false" Visible="false" TabIndex="9" CssClass="ItDoseButton" OnClientClick="" />
                <asp:Button ID="btnUpdate" TabIndex="10" runat="server" Text="Update"  CausesValidation="false"  Visible="false" CssClass="ItDoseButton" OnClientClick="" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" TabIndex="11" runat="server" Text="Cancel" CssClass="ItDoseButton" Visible="false" OnClick="btnCancel_Click" />
                <asp:Button ID="btnPrintNurNote" runat="server" Text="Print Notes"  OnClick="btnPrintNurNote_Click" />
            </div>

            <div class="POuter_Box_Inventory" style="overflow: scroll;">
                <div class="Purchaseheader" style="height: 19px;">
                    Results
                </div>
                <table id="tbNursingprogress">
                    <tr>
                        <td>
                            <div style="text-align: center;">
                                <asp:GridView ID="grdNursing" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdNursing_RowDataBound" OnRowCommand="grdNursing_RowCommand">

                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>

                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>

                                            <ItemStyle CssClass="GridViewItemStyle" ></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lbldate" runat="server" Text='<%#Eval("DATETIME") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("TIME") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Goal/Object">
                                            <ItemTemplate>
                                                <asp:Label ID="lblGoalObject" runat="server" Text='<%#Eval("GoalObject") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="226px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" VerticalAlign="Middle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Nursing Intervention/Management Plan">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNursingInterventionManagementPlan" runat="server" Text='<%#Eval("NursingInterventionManagementPlan") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                       
                                        <asp:TemplateField HeaderText="Rationale">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRationale" runat="server" Text='<%#Eval("Rationale") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="226px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Implementation">
                                            <ItemTemplate>
                                                <asp:Label ID="lblImplementation" runat="server" Text='<%#Eval("Implementation") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="EvaluationOutcome">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEvaluationOutcome" runat="server" Text='<%#Eval("EvaluationOutcome") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="ActiveEvaluated">
                                            <ItemTemplate>
                                                <asp:Label ID="lblActiveEvaluated" runat="server" Text='<%#Eval("ActiveEvaluated") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle"  />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="NursingDiagnosis">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNursingDiagnosis" runat="server" Text='<%#Eval("NursingDiagnosis") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                         
                                        <asp:TemplateField HeaderText="Entry By">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("EntryBy") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Edit" Visible="false">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit"  CausesValidation="false"  CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                <asp:Label ID="lblUserID" Text='<%#Eval("CreateUserID") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="FALSE"></asp:Label>
                                                <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>

                                    </Columns>
                                    <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" PageButtonCount="5" />
                                </asp:GridView>
                            </div>

                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>

</body>
</html>
