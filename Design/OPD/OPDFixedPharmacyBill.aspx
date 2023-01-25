<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OPDFixedPharmacyBill.aspx.cs" Inherits="Design_OPD_OPDFixedPharmacyBill" MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Fixed Pharmacy Bill</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" Style="display: none"></asp:TextBox>
            <asp:Label ID="lblIPDAdvanceRefund" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                 
                    <div class="row">
                        <div class="col-md-3" style="display: none;">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display: none;">
                            <asp:TextBox ID="txtTransactionId" runat="server" AutoCompleteType="Disabled" TabIndex="1" ToolTip="Enter IPD No." MaxLength="10"></asp:TextBox>

                        </div>
                        <div class="col-md-3" style="display: none;">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display: none;">
                            <asp:TextBox ID="txtPatientName" runat="server" AutoCompleteType="Disabled"
                                TabIndex="2" ToolTip="Enter Patient Name"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientID" runat="server" AutoCompleteType="Disabled"
                                TabIndex="3" ToolTip="Enter Registration No."></asp:TextBox>
                        </div>
                        <div class="col-md-5">
                             <input type="button" id="btnSearch"  value="Search" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            
        </div>
        <div class="POuter_Box_Inventory" id="dvSearchResult" style="display: none;">
            <div class="Purchaseheader">
                Details
            </div>
            <div id="dvFixedPharmacyDetail" style="overflow: auto;">
            </div>
        </div>
        <div id="gdhide">
            <asp:Panel ID="pnlDetails" runat="server" Style="display: none;">
                <asp:Label ID="lblIPDAdvance" runat="server" Style="display: none"></asp:Label>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <div class="Purchaseheader">
                        Insert Details
                    </div>

                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Patient Name</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">UHID</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblPatientID" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    <asp:Label ID="lblpid" runat="server" Style="display: none;" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                </div>

                            </div>


                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Address</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblPaddress" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Panel</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblPanelComp" runat="server" CssClass="ItDoseLabelSp pull-left "></asp:Label>
                                </div>
                            </div>


                          
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Refereal No  </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtReferealNo" AutoComplete="off" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Max Bill No Allow </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtMaxBillAllow" AutoComplete="off" decimalplace="4" onlynumber="100" MaxLength="3" CssClass="ItDoseTextinputNum" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>


                </div>
                <div id="divSave" class="POuter_Box_Inventory" style="text-align: center;">
                    <input type="button" style="width: 100px; margin-top: 7px" id="btnSave" runat="server" class="ItDoseButton" value="Save" onclick="save(this)" />
                </div>
            </asp:Panel>
        </div>
        
        
        <div class="POuter_Box_Inventory" id="dvPatientHistory" style="display: none;">
            <div class="Purchaseheader">
                Patient History
            </div>
            <div id="dvPatientHistoryDetail" style="overflow: auto;">
            </div>

        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%=txtPatientID.ClientID%>').focus();
        
            $("#btnSearch").click(function () { getPatientDetails();  });
         
        });


        function getPatientDetails() {
            $("#dvSearchResult,#dvFixedPharmacyDetail").hide();
            $("#btnSearch").val("Searching...").attr("disabled", true);
            serverCall('opdfixedpharmacybill.aspx/getPatientDetails', { PatientId: $.trim($('#<%=txtPatientID.ClientID%>').val()) }, function (response) {
                responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    var htmlOutPut = $("#scrptFixedPharamacyBill").parseTemplate(responseData);
                    $("#dvFixedPharmacyDetail").html(htmlOutPut);
                    $("#btnSearch").val("Search").attr("disabled", false);
                    $("#dvSearchResult,#dvFixedPharmacyDetail").show();
                }
                else {
                 //modelAlert('No Record Found', function () { });
                    $("#btnSearch").val("Search").attr("disabled", false);
                }
            });


        }

        function getPatientHistory() {

            $("#dvPatientHistory,#dvPatientHistoryDetail").hide();
            $("#btnSearchHistory").val("Searching...").attr("disabled", true);
            serverCall('opdfixedpharmacybill.aspx/getPatientHistory', { PatientId: $.trim($('#<%=lblPatientID.ClientID%>').text()) }, function (response) {
                responseData2 = JSON.parse(response);
                if (responseData2.length > 0) {
                    var htmlOutPut = $("#scriptPatientHistory").parseTemplate(responseData2);
                    $("#dvPatientHistoryDetail").html(htmlOutPut);
                    $("#btnSearchHistory").val("Search").attr("disabled", false);
                    $("#dvPatientHistory,#dvPatientHistoryDetail").show();
                }
                else {
                   // modelAlert('No Record Found', function () { });
                    $("#btnSearchHistory").val("Search").attr("disabled", false);
                }
            });

        }




        var getDetails = function (callback) {
            var data = {
                pid: $.trim($('#<%=lblpid.ClientID%>').text()),
                patientID: $.trim($('#<%=lblPatientID.ClientID%>').text()),
                referealno: $('#<%=txtReferealNo.ClientID%>').val().trim(),
                maxbillallow: $('#<%=txtMaxBillAllow.ClientID%>').val().trim()
            }
            callback(data);
        }

        var getFixedPharmacyBillDetails = function (callback) {
            getDetails(function (data) {
                callback(data);
            });
        }


        var save = function (btnSave) {
            getFixedPharmacyBillDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('opdfixedpharmacybill.aspx/Save', data, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            clearAll();
                            getPatientHistory();
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }


        function clearAll() {
            $('#<%=lblpid.ClientID%>').text('');
            $('#<%=lblPatientID.ClientID%>').text('');
            $('#<%=lblPatientName.ClientID%>').text('');
            $('#<%=lblPaddress.ClientID%>').text('');
            $('#<%=lblPanelComp.ClientID%>').text('');
            $('#<%=txtMaxBillAllow.ClientID%>').val('');
            $('#<%=txtReferealNo.ClientID%>').val('');

            $('#<%=btnSave.ClientID%>').removeAttr('disabled').val('Save');
            $('#<%=pnlDetails.ClientID%>').hide();

        }




        function viewPatientDetail(img) {
            var row = $(img).closest("tr");
            var data = JSON.parse($(row).find("#tdData").text());
            $('#<%=lblPatientID.ClientID%>').text(data.PatientID);
            $('#<%=lblPatientName.ClientID%>').text(data.pname);
            $('#<%=lblPaddress.ClientID%>').text(data.Address);
            $('#<%=lblPanelComp.ClientID%>').text(data.PanelName);

            getPatientHistory();

            $('#<%=pnlDetails.ClientID%>').show();

        }


        function viewPatientHistory(img) {
            var row = $(img).closest("tr");
            var data = JSON.parse($(row).find("#tdData2").text());
            $('#<%=lblpid.ClientID%>').text(data.ofpbid);
            $('#<%=lblPatientID.ClientID%>').text(data.PatientID);
            $('#<%=lblPatientName.ClientID%>').text(data.pname);
            $('#<%=lblPaddress.ClientID%>').text(data.Address);
            $('#<%=lblPanelComp.ClientID%>').text(data.PanelName);
            $('#<%=txtMaxBillAllow.ClientID%>').val(data.MaxBillAllow);
            $('#<%=txtReferealNo.ClientID%>').val(data.ReferealNo);
            $('#<%=pnlDetails.ClientID%>').show();

            if (data.ofpbid != '') {
                $('#<%=btnSave.ClientID%>').removeAttr('disabled').val('Update');
            }
        }

        function cancelRecord(img) {
            var row = $(img).closest("tr");
            var data = JSON.parse($(row).find("#tdData2").text());
            modelConfirmation('Confirmation !', 'Do you want to delete ?', 'Delete', 'Cancel', function (status) {
                if (status) {
                    serverCall('opdfixedpharmacybill.aspx/cancelRecord', { pid: data.ofpbid, patientID: data.PatientID }, function (response) {
                        var $responseData = JSON.parse(response);
                        modelAlert($responseData.response, function () {
                            if ($responseData.status) {
                                getPatientHistory();
                            }

                        });
                    });
                }

            });

        }

    </script>

    <style type="text/css">
        #divPaymentControlParent {
            border: none;
        }
    </style>
    


    <script type="text/html" id="scriptPatientHistory">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:100%" >
		    <tr id="Tr1"> 
                       
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">#</th>                
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Address</th>
                <th class="GridViewHeaderStyle" scope="col" >ReferealNo</th>
                <th class="GridViewHeaderStyle" scope="col" >MaxBillAllow</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Edit</th>  
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Cancel</th>     
             </tr>
            <#       
		    var dataLength=responseData2.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow; 
            var strStyle="";            
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = responseData2[j];
               
                      
		    #>
            <tr id="Tr2" class="<#=strStyle#>">                
               
                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#></td>                                      
                <td class="GridViewLabItemStyle" id="td3" style="text-align:left;"><#=objRow.PatientID#></td>    
				<td class="GridViewLabItemStyle" id="td4" style="text-align:left;"><#=objRow.pname#></td> 
                <td class="GridViewLabItemStyle" id="td5" style="text-align:center;"><#=objRow.Address#></td>
                <td class="GridViewLabItemStyle" id="td6" style="text-align:center;"><#=objRow.ReferealNo#></td>
                <td class="GridViewLabItemStyle" id="td7" style="text-align:center;"><#=objRow.MaxBillAllow#></td>
                <td class="GridViewLabItemStyle tdData" id="tdData2" style="display:none"><#=JSON.stringify(objRow) #></td> 
                         <td class="GridViewLabItemStyle" id="td9" style="width:50px;text-align:center;">
                        <img id="img1" src="../../Images/edit.png" style="cursor:pointer;" title="Click To Edit" onclick="viewPatientHistory(this);"/>
                </td>      
                 <td class="GridViewLabItemStyle" id="td10" style="width:30px;text-align:center;">
                    <#if(objRow.ofpbid!=''){#>
                        <img id="img2" src="../../Images/Delete.gif" style="cursor:pointer;" title="Click To Cancel " onclick="cancelRecord(this);"/>
                    <#}#>
                </td> 
                              
            </tr>              
		    <#}        
		    #>                    
        </table>
    </script>
    <script type="text/html" id="scrptFixedPharamacyBill">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:100%" >
		    <tr id="tdHeader"> 
                       
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">#</th>                
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Gender</th>
                <th class="GridViewHeaderStyle" scope="col" >Panel</th>
                <th class="GridViewHeaderStyle" scope="col" >Address</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;"></th>      
             </tr>
            <#       
		    var dataLength=responseData.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow; 
            var strStyle="";  
               
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = responseData[j];
               
                      
		    #>
            <tr id="tdRow_<#=(j+1)#>" class="<#=strStyle#>">                
               
                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#></td>                                      
                <td class="GridViewLabItemStyle" id="tdPatientID" style="text-align:left;"><#=objRow.PatientID#></td>    
				<td class="GridViewLabItemStyle" id="tdPName" style="text-align:left;"><#=objRow.pname#></td>
                <td class="GridViewLabItemStyle" id="td11" style="text-align:left;"><#=objRow.gender#></td>  
                <td class="GridViewLabItemStyle" id="td2" style="text-align:left;"><#=objRow.PanelName#></td>  
                <td class="GridViewLabItemStyle" id="td1" style="text-align:center;"><#=objRow.Address#></td>
                <td class="GridViewLabItemStyle tdData" id="tdData" style="display:none"><#=JSON.stringify(objRow) #></td> 
                         <td class="GridViewLabItemStyle" id="tdUpdate" style="width:50px;text-align:center;">
                        <img id="imgViewRecord" src="../../Images/Post.gif" style="cursor:pointer;" title="Click To Insert" onclick="viewPatientDetail(this);"/>
                </td>              
            </tr>              
		    <#}  
                #>  
		              
        </table>
    </script>
</asp:Content>
