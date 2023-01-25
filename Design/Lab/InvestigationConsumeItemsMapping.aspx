<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvestigationConsumeItemsMapping.aspx.cs" Inherits="Design_OPD_InvestigationConsumeItemsMapping" MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">

        $(document).ready(function () {

            $ControlInit(function () { });

        })

        var $ControlInit = function (callback) {
            $bindInvestigation(function () {

                $bindInvestigationItem(function () {

                    callback(true);
                });

            });


        }

        var $bindInvestigation = function (callback) {
            serverCall('InvestigationConsumeItemsMapping.aspx/bindConsumeInvestigation', {}, function (response) {
                $ddlInvestigation = $('#ddlInvestigation');
                $ddlInvestigation.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Investigation_Id', textField: 'InvestigationName', isSearchAble: true });

                callback($ddlInvestigation.val());

            });
        }
        var $bindInvestigationItem = function (callback) {
            serverCall('InvestigationConsumeItemsMapping.aspx/bindConsumeInvestigationItem', {}, function (response) {
                $ddlInvestigationItem = $('#ddlInvestigationItem');
                $ddlInvestigationItem.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ItemID', textField: 'ItemName', isSearchAble: true });

                callback($ddlInvestigationItem.val());

            });
        }
    </script>
    
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Investigation Consume Items Mapping</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div id="gdhide">
            <asp:Panel ID="pnlDetails" runat="server" >
                <div class="POuter_Box_Inventory" style="text-align: center;">
           
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Investigation</label>
                                    <b class="pull-right">:</b>
                                    <asp:Label ID="lblpid" runat="server" Style="display: none;" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                </div>
                                <div class="col-md-5">
                                    <select id="ddlInvestigation" data-title="Select Investigation"  onchange="getHistory();"  ></select>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left"> Item </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <select id="ddlInvestigationItem" data-title="Select Investigation Item"></select>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Qty. </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtQty"  AutoComplete="off"  onlynumber="10"  Text="0" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Department </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input id="rdoLab" type="radio" name="rdoDepartment" value="LSHHI112" checked="checked" />Laboratory
							        <input id="rdoRad" type="radio" name="rdoDepartment" value="LSHHI113"  />Radiology  
                                </div>
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
    
        function getHistory() {
       
            $("#dvPatientHistory,#dvPatientHistoryDetail").hide();
            $("#btnSearchHistory").val("Searching...").attr("disabled", true);
            serverCall('InvestigationConsumeItemsMapping.aspx/getDetail', { investigation_id: $.trim($('#ddlInvestigation').val()) }, function (response) {
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




        var getDetail = function (callback) {
            var data = {
                pid: $.trim($('#<%=lblpid.ClientID%>').text()),
                investigationId: $.trim($('#ddlInvestigation').val()),
                itemId: $.trim($('#ddlInvestigationItem').val()),
                qty: $('#<%=txtQty.ClientID%>').val().trim(),
                department:$('input[name="rdoDepartment"]:checked').val()
            }
            callback(data);
        }

        var getDetails = function (callback) {
            getDetail(function (data) {
                callback(data);
            });
        }


        var save = function (btnSave) {
            getDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('InvestigationConsumeItemsMapping.aspx/Save', data, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            clearAll();
                            getHistory();
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }


        function clearAll() {
            $('#<%=lblpid.ClientID%>').text('');

            $('#ddlInvestigationItem').val(0).chosen('destroy').chosen();//
            $('#<%=txtQty.ClientID%>').val(0);
            $('#<%=btnSave.ClientID%>').removeAttr('disabled').val('Save');
        }






        function viewDetail(img) {

            var row = $(img).closest("tr");
            var data = JSON.parse($(row).find("#tdData2").text());
            $('#<%=lblpid.ClientID%>').text(data.pid);
            

            $('#ddlInvestigation').val(data.InvestigationId).chosen('destroy').chosen();//
            $('#ddlInvestigationItem').val(data.ItemId).chosen('destroy').chosen();//

            $('#<%=txtQty.ClientID%>').val(data.Qty);
            $("input[name=rdoDepartment][value=" + data.DeptLedgerNo + "]").prop('checked', true);
            $('#<%=pnlDetails.ClientID%>').show();

            if (data.pid != '') {
                $('#<%=btnSave.ClientID%>').removeAttr('disabled').val('Update');
            }
        }

        function cancelRecord(img) {
            var row = $(img).closest("tr");
            var data = JSON.parse($(row).find("#tdData2").text());
            modelConfirmation('Confirmation !', 'Do you want to delete ?', 'Delete', 'Cancel', function (status) {
                if (status) {
                    serverCall('InvestigationConsumeItemsMapping.aspx/cancelRecord', { pid: data.pid }, function (response) {
                        var $responseData = JSON.parse(response);
                        modelAlert($responseData.response, function () {
                            if ($responseData.status) {
                                getHistory();
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
                <th class="GridViewHeaderStyle" scope="col" >Investigation</th>
                <th class="GridViewHeaderStyle" scope="col" >Item Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Qty</th>
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
                <td class="GridViewLabItemStyle" id="td3" style="text-align:left;"><#=objRow.InvestigationName #></td>    
				<td class="GridViewLabItemStyle" id="td4" style="text-align:left;"><#=objRow.TypeName #></td> 
                <td class="GridViewLabItemStyle" id="td5" style="text-align:left;"><#=objRow.Qty #></td> 
                <td class="GridViewLabItemStyle tdData" id="tdData2" style="display:none"><#=JSON.stringify(objRow) #></td> 
                         <td class="GridViewLabItemStyle" id="td9" style="width:50px;text-align:center;">
                        <img id="img1" src="../../Images/edit.png" style="cursor:pointer;" title="Click To Edit" onclick="viewDetail(this);"/>
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
    
</asp:Content>
