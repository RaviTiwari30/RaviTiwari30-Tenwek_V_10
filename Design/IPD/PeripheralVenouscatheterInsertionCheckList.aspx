<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PeripheralVenouscatheterInsertionCheckList.aspx.cs" Inherits="Design_IPD_PeripheralVenouscatheterInsertionCheckList" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%-- <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>--%>
    <style type="text/css">
        .col-md-16 {
              display: flex;
            }
        .col-md-16 > div {
                  border: 1px solid black;
                }
            
    </style>
</head>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
   <%-- <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#spnPatientID").text('<%=Request.QueryString["PID"].ToString() %>');
            $("#spnTransactionID").text('<%=Request.QueryString["TID"].ToString() %>');
            //bindData();
        });
        function validate()
        {
            if ( $('#txtPersonInserting').val() == "" && $('#txtLocation').val() == "" && $('#txtLeftCatheterGauge').val() == "" && $('#txtReason').val() == "" && $('#txtCatheterSiteCleanedWith').val() == "" && $('#txtEaseOfInsertion').val() == "" && $('#txtPatientComplianceLevel').val() == "" && $('#txtAppearenceOfCatheterSite').val() == "" && $('#txtCatheterFlushedWith').val() == "")
            {
                modelAlert("Please Fill Details.", function () { });
                return false;
            }
            }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>Peripheral Venous Catheter Insertion CheckList </b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   Peripheral Venous Catheter Insertion CheckList
                </div>
 
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <div class="col-md-3">Date of Insertion
                        </div>
                     <div class="col-md-5">
                          <span  style="display:none;"  id="spnTransactionID"></span>
                   
                        <span style="display:none;" id="spnPatientID"></span>
                        
                        <span  style="display:none;"  id="spnEditPatientNote"></span>
                                   <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                        </div>
                     <div class="col-md-3">Time of Insertion
                        </div>
                     <div class="col-md-8">
                          <asp:TextBox ID="txtTime" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            
                        </div>
                    </div>
                </div>
                 
 
            <div class="POuter_Box_Inventory" style="text-align: left;">
                <div class="row">
                    <div class="col-md-24">
                        <table style="width:100%;" class="FixedTables" >
                            <tr><th class="GridViewHeaderStyle" >Sr. No.</th><th class="GridViewHeaderStyle" >CATHETER INSERTION PROCEDURE</th><th class="GridViewHeaderStyle" >RESPONSE</th></tr>
                        <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >1</td>
                              <td class="GridViewLabItemStyle" >Name Of Person Inserting</td>
                              <td class="GridViewLabItemStyle" >
                                   <asp:TextBox ID="txtPersonInserting" CssClass="" runat="server" Width="400px"  ClientIDMode="Static" MaxLength="50" ></asp:TextBox>
                        
                              </td>
                        </tr>
                         <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >2</td>
                              <td class="GridViewLabItemStyle" >Location Of Peripheral Catheter(e.g. left cephalic vein)</td>
                              <td class="GridViewLabItemStyle" >
                                  <asp:TextBox ID="txtLocation" CssClass="" runat="server"  Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                          
                              </td>
                        </tr> 
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >3</td>
                              <td class="GridViewLabItemStyle" >Left Catheter Gauge</td>
                              <td class="GridViewLabItemStyle" >
                                   <asp:TextBox ID="txtLeftCatheterGauge" CssClass="" runat="server" Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                         
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >4</td>
                              <td class="GridViewLabItemStyle" >Reason for Catheter Insertion(e.g. GA, Infusion IV Medications)
</td>
                              <td class="GridViewLabItemStyle" >
                                  <asp:TextBox ID="txtReason" CssClass="" runat="server"  Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                          
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >5</td>
                              <td class="GridViewLabItemStyle" >Catheter site cleaned with</td>
                              <td class="GridViewLabItemStyle" >
                                  <asp:TextBox ID="txtCatheterSiteCleanedWith" CssClass="" runat="server" Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                          
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >6</td>
                              <td class="GridViewLabItemStyle" >Ease of Insertion of  Catheter(e.g. First Attempt without Resistance)</td>
                              <td class="GridViewLabItemStyle" > <asp:TextBox ID="txtEaseOfInsertion" CssClass="" runat="server"  Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                        </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >7</td>
                              <td class="GridViewLabItemStyle" >Patient Compliance Level(e.g. Minimum Restraint Required)
</td>
                              <td class="GridViewLabItemStyle" ><asp:TextBox ID="txtPatientComplianceLevel" CssClass="" runat="server" Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                           </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >8</td>
                              <td class="GridViewLabItemStyle" >Appearance of  Catheter site and prior to insertion(e.g. Pain, Limb swelling, pressure sores Erithema OK )</td>
                              <td class="GridViewLabItemStyle" >
								<asp:TextBox ID="txtAppearenceOfCatheterSite" CssClass="" runat="server"  Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                          
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >9</td>
                              <td class="GridViewLabItemStyle" >Catheter Flushed With?</td>
                              <td class="GridViewLabItemStyle" >
                                   <asp:TextBox ID="txtCatheterFlushedWith" CssClass="" runat="server" Width="400px"  ClientIDMode="Static"  MaxLength="50" ></asp:TextBox>
                          
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >10</td>
                              <td class="GridViewLabItemStyle" >Checked By</td>
                              <td class="GridViewLabItemStyle" >
                                    <asp:TextBox ID="txtCheckedBy" CssClass="" runat="server"  Width="300px"  ClientIDMode="Static"  MaxLength="50"  disabled></asp:TextBox>
                         
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                              </td>
                        </tr>
                        </table>
                    </div>
                </div>
               
               
               
               
                
                </div>
                
            
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" ClientIDMode="Static" runat="server" OnClick="btnSave_Click" Text="save" CssClass="ItDoseButton"  OnClientClick="return validate();"   />
                <asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return validate();" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" Visible="false" OnClick="btnCancel_Click" />
               <%--  <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" TabIndex="69" OnClick="btnPrint_Click" />
            
              <input type="button" value="Save" id="btnSave" title="Save All Details" onclick="SaveData();" />--%>
            </div>
                 
             <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name Of Person Inserting">
                            <ItemTemplate>
                                <asp:Label ID="lblInsertedBy" runat="server" Text='<%#Eval("InsertedBy") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Location Of Peripheral Catheter">
                            <ItemTemplate>
                                <asp:Label ID="lblLocation" runat="server" Text='<%#Eval("Location") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Left Catheter Gauge">
                            <ItemTemplate>
                                <asp:Label ID="lblLeftCatheterGauge" runat="server" Text='<%#Eval("LeftCatheterGauge") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reason for Catheter Insertion">
                            <ItemTemplate>
                                <asp:Label ID="lblReason" runat="server" Text='<%#Eval("Reason") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Catheter site cleaned with">
                            <ItemTemplate>
                                <asp:Label ID="lblCatheterSiteCleanedWith" runat="server" Text='<%#Eval("CatheterSiteCleanedWith") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Ease of Insertion of Catheter">
                            <ItemTemplate>
                                <asp:Label ID="lblInsertionEase" runat="server" Text='<%#Eval("InsertionEase") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Patient Compliance Level" Visible="true">
                            <ItemTemplate>
                                <asp:Label ID="lblComplianceLevel" runat="server" Text='<%#Eval("ComplianceLevel") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Appearence of Catheter site and prior to insertion">
                            <ItemTemplate>
                                <asp:Label ID="lblAppearence" runat="server" Text='<%#Eval("Appearence") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Catheter Flushed With">
                            <ItemTemplate>
                                <asp:Label ID="lblFlushedWith" runat="server" Text='<%#Eval("FlushedWith") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Checked By">
                            <ItemTemplate>
                                <asp:Label ID="lblCheckedBy" runat="server" Text='<%#Eval("CheckedBy1")  %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientID" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID1" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Transaction ID" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("TransactionID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry By" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                                <asp:Label ID="lblCreatedID" runat="server" Text='<%#Eval("CreatedBy") %>' Visible="false"></asp:Label>
                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                <asp:Label ID="lblUserID" Text='<%#Eval("CreatedBy") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>  
                                            
                                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgbtnEdit1" AlternateText="Edit" CommandName="Print" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/print.gif" runat="server" />
                                                <asp:Label ID="lblID1" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                
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

