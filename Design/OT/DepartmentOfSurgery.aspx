<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DepartmentOfSurgery.aspx.cs" Inherits="Design_OT_PRE_DepartmentOfSurgery" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
<%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/chosen.jquery.min.js"></script>
    <link href="../../Styles/chosen.css" rel="stylesheet" />
 
</head>
<body>
    <form id="form1" runat="server">
        <ajax:ScriptManager ID="mgr" runat="server"></ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: center;">
                    DEPARTMENT OF SURGERY(OPERATION NOTES)
                </div>
                <div class="row" style="display:none">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Surgeon 1
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlSurgeon1" runat="server" TabIndex="1"></asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Anaesthetist
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlAnesthetsit" runat="server" TabIndex="2"></asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Surgeon 2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlSurgeon2" runat="server" TabIndex="3"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row" style="display:none">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Anaesthetic Tech
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlAnesthetsittech" runat="server" TabIndex="4"></asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Assistant Surgeon 1
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlAstSurgeon1" runat="server" TabIndex="5"></asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Scrub Nurse
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlScrubNurse" runat="server" TabIndex="6"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row" style="display:none">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Assistant Surgeon 2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlAstSurgeon2" runat="server" TabIndex="7"></asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Circulating Nurse
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlcalNurse" runat="server" TabIndex="8"></asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Surgery Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtSurgeryDate" runat="server" ToolTip="Click To Select Date" Width="130px" TabIndex="9"></asp:TextBox>
                                <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="txtSurgeryDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                        </div>
                        <div class="row" style="display:none">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Surgery
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlSurgery" runat="server"></asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Urgency
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtUrgency" runat="server" ToolTip="Enter Urgency" MaxLength="500" TabIndex="10"></asp:TextBox>
                            </div>

                        </div>
                        <div class="row" style="display:none">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Start Time(Surgery)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <asp:TextBox ID="txtstartTime" CssClass="requiredField" runat="server" Width="86px" MaxLength="10" TabIndex="11" ToolTip="Enter Time "></asp:TextBox>

                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtstartTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtstartTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    End Time(Surgery)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <asp:TextBox ID="txtFinishTime" CssClass="requiredField" runat="server" Width="86px" MaxLength="10" TabIndex="12" ToolTip="Enter Time"></asp:TextBox>
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtFinishTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                                <cc1:MaskedEditValidator ID="maskfiTime" runat="server" ControlToValidate="txtFinishTime"
                                    ControlExtender="MaskedEditExtender2" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Pre operative Diagnosis
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtDiagnosis" ClientIDMode="Static" runat="server" Width="676px" Height="80px" TextMode="MultiLine" ToolTip="Enter Pre operative Diagnosis" TabIndex="13"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Post Operative Diagnosis
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtPostODiagnosi" ClientIDMode="Static" runat="server" Width="676px" Height="90px" TextMode="MultiLine" ToolTip="Enter Post Operative Diagnosis" TabIndex="14"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Anesthesia Type
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <div class="row">
                            <asp:DropDownList ID="ddlAnesthesiatype" runat="server">
                                <asp:ListItem Text="Select" Value="Select"></asp:ListItem>
                                <asp:ListItem Text="Local" Value="Local"></asp:ListItem>
                                <asp:ListItem Text="General" Value="General"></asp:ListItem>
                                <asp:ListItem Text="Sedation" Value="Sedation"></asp:ListItem>
                                <asp:ListItem Text="Spinal" Value="Spinal"></asp:ListItem>
                                <asp:ListItem Text="Regional" Value="Regional"></asp:ListItem>
                                <asp:ListItem Text="MAC" Value="MAC"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Team Involved
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="row">
                            <asp:DropDownList ID="ddlSurgeonassign" runat="server" Visible="false">
                            </asp:DropDownList>
                            <div id="divTATStaffTiming" style="width: 100%; max-height: 200px; overflow-y: auto">
                                <table id="tblSelectedStaff" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <%--<tr id="IssueItemHeader">
                                            <th class="GridViewHeaderStyle" scope="col" style="display: none;">S.No.</th>
                                            <th class="GridViewHeaderStyle" scope="col">Staff Type</th>
                                            <th class="GridViewHeaderStyle" scope="col">Staff Person Name</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="display: none;">IN Time</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="display: none;">OUT Time</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="display: none;"></th>
                                            <th class="GridViewHeaderStyle" scope="col" style="display: none;"></th>
                                            <th class="GridViewHeaderStyle" scope="col" style="display: none;"></th>
                                        </tr>--%>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>

                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Procedures 
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">
                                    Primary  Procedure 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                
                                <asp:DropDownList ID="ddlPrimaryProcedure" runat="server"  ClientIDMode="Static"></asp:DropDownList>

                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">
                                    Secondary  Procedure 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlSecondaryProcedure" runat="server" ClientIDMode="Static"></asp:DropDownList>
                            </div>
                            
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">
                                      Procedure Template 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">

                                <asp:DropDownList ID="ddlProcedure" runat="server" OnSelectedIndexChanged="ddlProcedure_SelectedIndexChanged" AutoPostBack="true" TabIndex="25" ></asp:DropDownList>
                            </div>

                            <div class="col-md-5" style="text-align:right">
                                 <label class="pull-left">
                                      Other Procedure 
                                </label>
                                 <asp:CheckBox ClientIDMode="Static" runat="server" onchange="ShowHideOtherSurgeryTextBox()" ID="chkIsOtherSurgery"   />
                                <b class="pull-right">:</b>                               
                            </div>

                            <div class="col-md-5">
                                <asp:TextBox runat="server" ID="txtOtherSurgery" Style="display: none" ClientIDMode="Static"></asp:TextBox>
                            </div>

                        </div>
                        <div class="row">
                            <CKEditor:CKEditorControl ID="txtProcedures" BasePath="~/ckeditor" runat="server" EnterMode="BR" TabIndex="26"></CKEditor:CKEditorControl>
                        </div>
                    </div>
                </div>
            </div>


            <div class="POuter_Box_Inventory" style="display: none">
                <div class="Purchaseheader" style="text-align: left;">
                    Operation
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtOperation" ClientIDMode="Static" runat="server" Width="676px" Height="80px" TextMode="MultiLine" ToolTip="Enter Operation" TabIndex="15"></asp:TextBox>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Incisions 1
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtIncisions1" runat="server" ToolTip="Enter Incisions 1" MaxLength="500" TabIndex="16"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Incisions 2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtIncisions2" runat="server" ToolTip="Enter Incisions 2" MaxLength="500" TabIndex="17"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Ports
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPorts" runat="server" ToolTip="Enter Ports" MaxLength="500" TabIndex="18"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Anesthesia
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtAnesthesia" runat="server" ToolTip="Enter Anesthesia" MaxLength="100" TabIndex="19"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Findings
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtfindings" ClientIDMode="Static" runat="server" Width="676px" Height="80px" TextMode="MultiLine" ToolTip="Enter Findings" TabIndex="20"></asp:TextBox>
                        </div>
                    </div>
                </div>

            </div>


            <div class="POuter_Box_Inventory" style="display: none">
                <div class="Purchaseheader" style="text-align: left;">
                    Sample (Tissue) sent for Histopathology <%--(if any)--%>
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtsample" ClientIDMode="Static" runat="server" Width="676px" Height="40px" TextMode="MultiLine" ToolTip="Enter Sample" TabIndex="23"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Complications <%--(if any)--%>
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtcomplications" ClientIDMode="Static" runat="server" Width="676px" Height="40px" TextMode="MultiLine" ToolTip="Enter Complications" TabIndex="24"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Counts correct
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtClousre" ClientIDMode="Static" runat="server" Width="676px" Height="80px" TextMode="MultiLine" ToolTip="Enter Closure" TabIndex="22"></asp:TextBox>
                        </div>
                    </div>
                </div>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Drains
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtDrains" ClientIDMode="Static" runat="server" Width="676px" Height="50px" TextMode="MultiLine" ToolTip="Enter Drains" TabIndex="21"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Classification
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                Department :
                            </div>

                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlDepartment" runat="server">
                                    <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                    <asp:ListItem Text="OB/GYN" Value="OB/GYN"></asp:ListItem>
                                    <asp:ListItem Text="General Surgery" Value="General Surgery"></asp:ListItem>
                                    <asp:ListItem Text="Paediatric Surgery" Value="Paediatric Surgery"></asp:ListItem>
                                    <asp:ListItem Text="Neurosurgery" Value="Neurosurgery"></asp:ListItem>
                                    <asp:ListItem Text="Cardiothracic Surgery" Value="Cardiothracic Surgery"></asp:ListItem>
                                    <asp:ListItem Text="Endoscopy" Value="Endoscopy"></asp:ListItem>
                                    <asp:ListItem Text="Orthopedic Surgery" Value="Orthopedic Surgery"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="col-md-4">
                                Nature of Surgery :
                            </div>

                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlNatureOfSurgery" runat="server">
                                    <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Elective" Value="Elective"></asp:ListItem>
                                    <asp:ListItem Text="Urgent" Value="Urgent"></asp:ListItem>
                                    <asp:ListItem Text="Emergent" Value="Emergent"></asp:ListItem>

                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                Wound Classification :
                            </div>

                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlWoundClassification" runat="server">
                                    <asp:ListItem Text="Select" Value=""></asp:ListItem>
                                    <asp:ListItem Text="I. Clean" Value="I. Clean"></asp:ListItem>
                                    <asp:ListItem Text=" II. Clean Contaminated" Value=" II. Clean Contaminated"></asp:ListItem>
                                    <asp:ListItem Text=" III. Contaminated" Value=" III. Contaminated"></asp:ListItem>
                                    <asp:ListItem Text="IV. Dirty" Value="IV. Dirty"></asp:ListItem>
                                    <asp:ListItem Text="No wound" Value="No wound"></asp:ListItem>

                                </asp:DropDownList>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory" style="display: none">
                <div class="Purchaseheader" style="text-align: left;">
                    Blood Loss
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtbloodloss" ClientIDMode="Static" runat="server" Width="676px" Height="30px" TextMode="MultiLine" ToolTip="Enter  Blood Loss" TabIndex="27"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="display: none">
                <div class="Purchaseheader" style="text-align: left;">
                    Post Operative Instructions
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtPostOInstructions" ClientIDMode="Static" runat="server" Width="676px" Height="80px" TextMode="MultiLine" ToolTip="Enter Post Operative Instructions" TabIndex="28"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" >
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <b>Entry Details :</b>
                            </div>                           
                            <div class="col-md-21" style="text-align: center ">
                                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" TabIndex="29" />
                                <asp:Button ID="btnprint" runat="server" CssClass="ItDoseButton" Text="Print" OnClick="btnprint_Click" TabIndex="29" Visible="false" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <%#Eval("EntryBy") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>                        
                        <asp:TemplateField HeaderText="EntryDate">
                            <ItemTemplate>
                                <%#Eval("EntryTime") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>                      
                        <asp:TemplateField HeaderText="Print" Visible="true">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandName="imbPrint" Visible="true"
                                    CommandArgument='<%# Eval("ID") %>' ImageUrl="~/Images/print.gif" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        function ShowHideOtherSurgeryTextBox() {

            var isChecked = $("#chkIsOtherSurgery").is(":checked");
            if (isChecked) {
                $("#txtOtherSurgery").show();
            } else {
                $("#txtOtherSurgery").hide();
            }

             
        }

        $(document).ready(function () {

            $('#ddlPrimaryProcedure,#ddlSecondaryProcedure').chosen();
            ShowHideOtherSurgeryTextBox();
            bindSavedStaff();
        });
        var bindSavedStaff = function () {
            serverCall('DepartmentOfSurgery.aspx/bindSavedStaff', { OTBookingID: Number('<%=Util.GetInt(ViewState["LedgerTransactionNo"])%>') }, function (response) {
                 var responseData = JSON.parse(response);
                 if (responseData.length > 0) {
                     for (j = 0; j < responseData.length; j++) {
                         addNewRow(responseData[j].StaffTypeID, responseData[j].StaffTypeName, responseData[j].StaffID, responseData[j].StaffName, responseData[j].StartTime, responseData[j].EndTme, function () { });
                     }
                 }
             });
         }
        var addNewRow = function (typeID, typeName, staffID, staffName, InTime, OutTime, callback) {
            var table = $('#tblSelectedStaff tbody');
            var newRow = $('<tr>').attr('id', 'tr_' + staffID);
            newRow.html(
                              '</td><td class="GridViewLabItemStyle" id="tdSrNo" style="text-align:center;display:none;">' + (table.find('tr').length + 1) +
                              '</td><td class="GridViewLabItemStyle" id="tdtypeName"><b>' + typeName +
                              '</b>:</td><td class="GridViewLabItemStyle" id="tdstaffName">' + staffName +
                              '</td><td class="GridViewLabItemStyle" id="tdInTime" style="width:67px;display:none;">' + InTime +
                              '</td><td class="GridViewLabItemStyle" id="tdOutTime" style="width:67px;display:none;">' + OutTime +
                              '</td><td class="GridViewLabItemStyle" id="tdstaffTypeID" style="display:none;" >' + typeID +
                              '</td><td class="GridViewLabItemStyle" id="tdstaffID" style="display:none;" >' + staffID +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none;" id="imgRemove"><img id="imgRmv" class="btn" src="../../Images/Delete.gif" onclick="removeRow(this);" style="cursor:pointer;" title="Click To Remove"/></td>'
                              );
            table.append(newRow);
            callback(true);
        }

    </script>
</body>
</html>
