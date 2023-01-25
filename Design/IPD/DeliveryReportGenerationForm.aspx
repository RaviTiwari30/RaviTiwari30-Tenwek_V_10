<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeliveryReportGenerationForm.aspx.cs" Inherits="Design_IPD_DeliveryReportGenerationForm" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>

</head>
<body>

    <script src="../../Scripts/Common.js" type="text/javascript"></script>

    <form id="form1" runat="server">
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
        <script type="text/javascript">
            $(document).ready(function () {
                var MaxLength = 2000;
                
            });
            function validate()
            {
               
            }
            function note() {
                $("#<%=lblMsg.ClientID%>").text('');
                document.getElementById('<%=btnSave.ClientID%>').disabled = False;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('btnSave', '');
            }
        </script>
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>Delivery Report Generation Form</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
         
            <div class="POuter_Box_Inventory" style="text-align: center;">
                              <div class="content">
                            <div class="row">
                                <div class="col-sm-2">

                                    
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Examination Date     </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtDate" runat="server"></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="caldate" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Examination Time </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-6">
                                   
                                    
                            <uc2:StartTime ID="StartTime" runat="server" />
                                </div>

                            </div>



                        </div>
        </div>
            <div class="POuter_Box_Inventory">
                <div class="content">
                    <div class="row">
                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Mother's encounter nr
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtMotherEncounterNr" runat="server" ToolTip="Mother's Encounter Nr" disabled ></asp:TextBox>
                                   
                                                                    </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                      Delivery Nr(para)
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtDeliveryNr" runat="server" ToolTip="Delivery Nr(para)" MaxLength="2" Width="120" ></asp:TextBox>
                                      <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtDeliveryNr" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                                                    </div>
                                    <div class="col-md-3">
                                    <label class="pull-left">
                                      Sex
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                 <asp:RadioButtonList ID="rdbGender" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="Male" >Male</asp:ListItem>
                                          <asp:ListItem Value="Female">Female</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>

                                    </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                      Delivery Place
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtDeliveryPlace"  runat="server" disabled></asp:TextBox>
                                </div>
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                      Delivery Mode
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-13">
                                 <asp:RadioButtonList ID="rdbDeliveryMode" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="Normal" >Normal</asp:ListItem>
                                          <asp:ListItem Value="Breech">Breech</asp:ListItem>
                                                <asp:ListItem Value="Caesarean" >Caesarean</asp:ListItem>
                                          <asp:ListItem Value="Forceps">Forceps</asp:ListItem>
                                      <asp:ListItem Value="Vacuum">Vacuum</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>

                                   
                            </div>
                             <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                      Reason If Caesarean
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtReasonIfCaesarean"  runat="server" ></asp:TextBox>
                                </div>
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                      Born Before Arrival
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                 <asp:RadioButtonList ID="rdbBornBeforeArrival" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>
                                  <div class="col-md-3">
                                    <label class="pull-left">
                                      Face Presentation
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                 <asp:RadioButtonList ID="rdbFacePresentation" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>
                                 </div>
                            
                             <div class="row">
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                    Posterio occipital Position 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                 <asp:RadioButtonList ID="rdbPosterioOccipitalPosition" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="Yes" >Yes</asp:ListItem>
                                          <asp:ListItem Value="No">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                      Delivery Rank
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtDeliveryRank"  runat="server" MaxLength="2"  Width="120" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtDeliveryRank" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                      
                                </div>
                                 </div>
                             <div class="row">
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                  Apgar Score 1 min.
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-13">
                                 <asp:RadioButtonList ID="rdbApgarScore1Min" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="0" >0</asp:ListItem>
                                          <asp:ListItem Value="1">1</asp:ListItem>
                                                <asp:ListItem Value="2" >2</asp:ListItem>
                                          <asp:ListItem Value="3">3</asp:ListItem>
                                                <asp:ListItem Value="4" >4</asp:ListItem>
                                          <asp:ListItem Value="5">5</asp:ListItem>
                                              
                                          <asp:ListItem Value="6">6</asp:ListItem>
                                          <asp:ListItem Value="7">7</asp:ListItem>
                                                <asp:ListItem Value="8" >8</asp:ListItem>
                                          <asp:ListItem Value="9">9</asp:ListItem>
                                                <asp:ListItem Value="10" >10</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>
                            </div>
                            <div class="row">
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                  Apgar Score 5 min.
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-13">
                                 <asp:RadioButtonList ID="rdbApgarScore5Min" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="0" >0</asp:ListItem>
                                          <asp:ListItem Value="1">1</asp:ListItem>
                                                <asp:ListItem Value="2" >2</asp:ListItem>
                                          <asp:ListItem Value="3">3</asp:ListItem>
                                                <asp:ListItem Value="4" >4</asp:ListItem>
                                          <asp:ListItem Value="5">5</asp:ListItem>
                                              
                                          <asp:ListItem Value="6">6</asp:ListItem>
                                          <asp:ListItem Value="7">7</asp:ListItem>
                                                <asp:ListItem Value="8" >8</asp:ListItem>
                                          <asp:ListItem Value="9">9</asp:ListItem>
                                                <asp:ListItem Value="10" >10</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>
                            </div>
                            <div class="row">
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                  Apgar Score 10 min.
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-13">
                                 <asp:RadioButtonList ID="rdbApgarScore10Min" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="0" >0</asp:ListItem>
                                          <asp:ListItem Value="1">1</asp:ListItem>
                                                <asp:ListItem Value="2" >2</asp:ListItem>
                                          <asp:ListItem Value="3">3</asp:ListItem>
                                                <asp:ListItem Value="4" >4</asp:ListItem>
                                          <asp:ListItem Value="5">5</asp:ListItem>
                                              
                                          <asp:ListItem Value="6">6</asp:ListItem>
                                          <asp:ListItem Value="7">7</asp:ListItem>
                                                <asp:ListItem Value="8" >8</asp:ListItem>
                                          <asp:ListItem Value="9">9</asp:ListItem>
                                                <asp:ListItem Value="10" >10</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>
                            </div>
                            <div class="row">
                            <div class="col-md-3">
                                    <label class="pull-left">
                                      Time To Spontan Respiration
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtTimeToSpontanRespiration"  runat="server" MaxLength="4" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtTimeToSpontanRespiration" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                
                                </div>
                            <div class="col-md-3">
                                    <label class="pull-left">
                                      Condition
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtCondition"  runat="server" ></asp:TextBox>
                                </div>
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                      Weight at Birth
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtWeightAtBirth"  runat="server" MaxLength="3" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtWeightAtBirth" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                </div>
                           
                                     </div>
                            <div class="row">
                            <div class="col-md-3">
                                    <label class="pull-left">
                                      Length at Birth
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtLengthAtBirth"  runat="server" MaxLength="3" ></asp:TextBox>
                                     <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtLengthAtBirth" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                </div>
                                  <div class="col-md-3">
                                    <label class="pull-left">
                                      Head Circumference
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtHeadCircumference"  runat="server"  MaxLength="3" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtHeadCircumference" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
 
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                      Scored Gestational Age
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtScoredGestationalAge"  runat="server"  MaxLength="3" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtScoredGestationalAge" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
 
                                </div>
                            </div>
                             <div class="row">
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                  Feeding
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-13">
                                 <asp:RadioButtonList ID="rdbFeeding" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="Breast" >Breast</asp:ListItem>
                                          <asp:ListItem Value="Formula">Formula</asp:ListItem>
                                                <asp:ListItem Value="Both" >Both</asp:ListItem>
                                          <asp:ListItem Value="Parenteral">Parenteral</asp:ListItem>
                                                <asp:ListItem Value="Never Fed" >Never Fed</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                    Congenital Abnormality
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtCongenitalAbnormality"  runat="server" ></asp:TextBox>
                                </div>
                            </div>
                            
                            <div class="row">
                            <div class="col-md-3">
                                    <label class="pull-left">
                                    Classification
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtClassification"  runat="server" ></asp:TextBox>
                                </div>
                                   <div class="col-md-3">
                                    <label class="pull-left">
                                  Outcome
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-13">
                                 <asp:RadioButtonList ID="rdbOutcome" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="Alive" >Alive</asp:ListItem>
                                          <asp:ListItem Value="Still Born">Still Born</asp:ListItem>
                                                <asp:ListItem Value="Early Neonatal Death" >Early Neonatal Death</asp:ListItem>
                                          <asp:ListItem Value="Late Neonatal Death">Late Neonatal Death</asp:ListItem>
                                                <asp:ListItem Value="Death Uncertain Timing" >Death Uncertain Timing</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>
                             </div>
                            <div class="row">
                             <div class="col-md-3">
                                    <label class="pull-left">
                                  Desease Category
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-13">
                                 <asp:RadioButtonList ID="rdbDeseaseCategory" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="Asphyxia" >Asphyxia</asp:ListItem>
                                          <asp:ListItem Value="Infection">Infection</asp:ListItem>
                                                <asp:ListItem Value="Congenital Abnormality" >Congenital Abnormality </asp:ListItem>
                                          <asp:ListItem Value="Trauma">Trauma</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </div>
                                 <div class="col-md-3">
                                    <label class="pull-left">
                                    Documented By
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtDocumentedBy" runat="server" disabled></asp:TextBox>
                                </div>
                           </div>

                            
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save"
                    TabIndex="7" OnClick="btnSave_Click" OnClientClick="return validate()" />
                <asp:Button ID="btnPrint" runat="server" CssClass="ItDoseButton" Text="Print"
                    TabIndex="7" OnClick="btnPrint_Click"  />
                  <asp:Button  ID="btnUpdate" runat="server" OnClientClick="return note()" Text="Update" OnClick="btnUpdate_Click" CssClass="ItDoseButton" Visible="false"/>
                   <asp:Button ID="bynCancel" runat="server" Text="Cancel" OnClick="bynCancel_Click" CssClass="ItDoseButton"  Visible="false"/>
                <asp:Label ID="lblID" runat="server"  Visible="false" ></asp:Label>
            </div>
            <asp:Panel ID="pnlhide" runat="server" Visible="true">
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <div class="Purchaseheader">
                       Delivery Report Generation 
                    </div>
                    <asp:GridView ID="grid" runat="server" CssClass="GridViewStyle"
                        AutoGenerateColumns="false"
                        OnRowDeleting="grid_RowDeleting" OnRowDataBound="grid_RowDataBound" OnRowCommand="grid_RowCommand" >
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="Date1" HeaderText="Date" 
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:TemplateField HeaderText="Entry By" HeaderStyle-Width="400px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblDocumentedBy" runat="server" Text='<%#Eval("EntryBy") %>'></asp:Label>
                                   
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Time" HeaderStyle-Width="400px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time1") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CausesValidation="false" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                            <asp:CommandField ShowDeleteButton="True" Visible="false"  HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderText="Remove" ItemStyle-HorizontalAlign="Center"
                                HeaderStyle-CssClass="GridViewHeaderStyle" ButtonType="Image" DeleteText="Remove Notes" DeleteImageUrl="~/Images/Delete.gif" />

                        </Columns>
                    </asp:GridView>
                    <br />


                </div>
            </asp:Panel>



        </div>
    </form>

    <script type="text/javascript">

        //*****Global Variables*******
        var items = [];
        //// END ////

        $(document).ready(function () {
            GetCodeData();
            $("#txtDate").prop('disabled', true);
            $("#StartTime_txtTime").prop('disabled', true);
            

        });


        function CheckSuggestedText(event, textId) {

            var str = $('#' + textId + '').val();
            if (str.indexOf("@") != -1) {
                var arr = str.split("@");

                // debugger;
                if (arr[arr.length - 1].length == 4) {
                    GetSuggestionText(arr[arr.length - 1], textId, event, function (callback) { })
                }
            }


        }


        function GetSuggestionText(code, textId, event, callback) {
            var str = $('#' + textId + '').val();
            var replacment = '@' + code;

            if (event.keyCode == 32) {
                var filteredValue = items.filter(function (item) {
                    return item.Code == code.toUpperCase();
                });
                if (filteredValue.length > 0) {

                    // If Want To Replace All  Matching Word from string Uncomment Bellow line 

                    /*
                    if (str.indexOf("@") != -1) {
                        var arr = str.split("@");
                    }
                    for (var i = 0; i < arr.length - 1; i++) {
                        str = str.replace(replacment, filteredValue[0].Description)

                    }
                    */

                    // this part only replace last occurrance 
                    var currentIndex = str.lastIndexOf(replacment);
                    str = str.substring(0, currentIndex) + filteredValue[0].Description;
                    /// 


                    $('#' + textId + '').val(str)

                }

            }
            callback(true)




        }


        function GetCodeData() {

            serverCall('../Employee/CodeMaster.aspx/GetActiveCodeData', {}, function (response) {

                var CodeData = JSON.parse(response);

                if (CodeData.status) {
                    data = CodeData.data;
                    items = data;

                    console.log(items)
                }

            });
        }


    </script>




</body>
</html>
