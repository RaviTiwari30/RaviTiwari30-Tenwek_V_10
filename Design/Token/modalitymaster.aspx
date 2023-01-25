<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ModalityMaster.aspx.cs" Inherits="Design_Token_ModalityMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">

        $(document).ready(function () {
            $bindSubCategory('1','7',function () {
                $bindFloor(function () {
                    bindCentre(function () {
                        bindModality('0', function () {
                            ClearFields(0);
                        });
                    });
                });
            });
        });

        
        var bindCentre = function (callback) {
            ddlCentre = $('#ddlCentre');
            serverCall('../Common/CommonService.asmx/BindAllCentre', {}, function (response) {
                var responseData = JSON.parse(response);
                ddlCentre.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
                callback(ddlCentre.val());
            });
        }

        $bindSubCategory = function (labItem, categoryID, callback) {
            $subCategory = $('#ddlSubCategory');
            serverCall('../common/CommonService.asmx/BindSubCategory', { Type: labItem, CategoryID: categoryID }, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true });
                callback($subCategory.val());
            });
        }
        $bindFloor = function (callback) {
            $ddlFloor = $('#ddlFloor');
            serverCall('ModalityMaster.aspx/BindFloor', {}, function (response) {
                $ddlFloor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
                callback($ddlFloor.val());
            });
        }

        var SaveModality = function () {
            var data = {
                subcategoryid : $('#ddlSubCategory').val(),
                modalityName: $('#txtModalityName').val().trim(),
                floor: $('#ddlFloor option:selected').val()==0 ? '' :$('#ddlFloor option:selected').text(),
                floorid :  $('#ddlFloor option:selected').val(),
                roomno: $('#txtRoomNo').val(),
                modalityID: $('#spnModalityID').text(),
                btnvalue: $('#btnSave').val(),
                Active: $('input[name=rdoactive]:checked').val(),
                centreID:$('#ddlCentre').val(),
            }
            if (data.subcategoryid=='0'){
                modelAlert('Please Select SubCategory');
                $('#ddlSubCategory').focus();
                return false;
            }
            if (String.isNullOrEmpty(data.modalityName)) {
                modelAlert('Please Modality Name');
                $('#txtModalityName').focus();
                return false;
            }
            serverCall('ModalityMaster.aspx/SaveModality', data, function (response) {
                var result = JSON.parse(response);
                modelAlert(result.message, function () {
                    bindModality(data.subcategoryid);
                    ClearFields(data.subcategoryid);
                });
            });

        }
        var bindModality = function (subcategoryId) {
            serverCall('ModalityMaster.aspx/SearchModality', { subcategoryId: subcategoryId,CentreID:$('#ddlCentre').val() }, function (response) {
                ResultData = jQuery.parseJSON(response);
                var output = $('#tb_Modality').parseTemplate(ResultData);
                $('#divOutPut').html(output);
                $('#divOutPut').show();
            });
        }

        var UpdateModality = function (rowID) {
            debugger;
            row = $(rowID).closest('tr');
            $('#txtModalityName').val(row.find('#tdModalityName').text());
            $('#ddlSubCategory').val(row.find('#tdSubCategoryID').text()).chosen('destroy').chosen();
            $('#ddlFloor').val(row.find('#tdFloor').text()).chosen('destroy').chosen();
            $('#txtRoomNo').val(row.find('#tdRoomNo').text());
            $('input[name=rdoactive]').filter('[value=' + row.find('#tdActive').text() + ']').prop('checked', true);
            $('#btnSave').val('Update');
            $('#spnModalityID').text(row.find('#tdmodalityID').text());
        }
        var ClearFields = function (subcategoryid) {
            $('#txtModalityName').val('');
            $('#ddlSubCategory').val(subcategoryid).chosen('destroy').chosen();
            $('#ddlFloor').val(0).chosen('destroy').chosen();
            $('#txtRoomNo').val('')
            $('input[name=rdoactive]').filter('[value=1]').prop('checked', true);
            $('#btnSave').val('Save');
            $('#spnModalityID').text('0');
            bindModality(subcategoryid);    
        }

    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            	<b>Modality Master</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCentre" class="requiredField" onchange="bindModality($('#ddlSubCategory').val(),function(){})"></select>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                SubCategory
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSubCategory" title="Selct SubCategory" class="requiredField" onchange="bindModality($('#ddlSubCategory').val(),function(){})"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Modality Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtModalityName" title="Enter Modality Name here" class="requiredField" />
                            <span id="spnModalityID" style="display:none">0</span>
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Floor</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlFloor" title="Selct Floor" ></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Room No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" id="txtRoomNo" title="Enter Room No here" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rdoactive" value="1" checked="checked" />Active
                            <input type="radio" name="rdoactive" value="0" />De-Active
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"></label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            
        </div>
         <div class="POuter_Box_Inventory">
              <div class="row" style="text-align:center">
                 <input type="button" id="btnSave" value="Save" onclick="SaveModality();" />
                     <input type="button" id="btnReset" value="Reset" onclick="ClearFields(0);" />
             </div>
         </div>
         <div class="POuter_Box_Inventory">
              <div class="Purchaseheader">
                Created Modality 
            </div>
              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div id="divOutPut" style="max-height: 250px; overflow-x: auto;"></div>
                    </div>
                    </div>
                <div class="col-md-1"></div>
                </div>
         </div>
    </div>


    <script type="text/html" id="tb_Modality">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_ModalityData" style="width:100%; border-collapse:collapse">
            <tr id="trHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Centre Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">SubCategory Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Modality Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Floor</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Room No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Active Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Edit</th>
		</tr>
            <#       
        var dataLength=ResultData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ResultData[j];
        #>
                <tr >                            
                    <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdmodalityID" style="width:200px; display:none" ><#=objRow.ID#></td> 
                    <td class="GridViewLabItemStyle" id="tdSubCategoryID" style="width:200px; display:none" ><#=objRow.SubCategoryID#></td> 
                    <td class="GridViewLabItemStyle" id="td1" style="width:100px;  text-align:center;" ><#=objRow.CentreName#></td> 
                    <td class="GridViewLabItemStyle" id="tdSubCategoryName" style="width:100px;  text-align:center;" ><#=objRow.SubcategoryName#></td> 
                    <td class="GridViewLabItemStyle" id="tdModalityName" style="width:80px;  text-align:center;" ><#=objRow.ModalityName#></td> 
                    <td class="GridViewLabItemStyle" id="tdFloor" style="width:80px;  text-align:center;" ><#=objRow.FLOOR#></td> 
                    <td class="GridViewLabItemStyle" id="tdRoomNo" style="width:80px;  text-align:center;" ><#=objRow.RoomNo#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" ><#=objRow.ActiveStatus#></td> 
                    <td class="GridViewLabItemStyle" id="tdActive" style="width:80px;  text-align:center; display:none" ><#=objRow.Isactive#></td> 
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center;" ><img id="imgSelect" src="../../Images/edit.png" onclick="UpdateModality(this);" title="Click To Update Modality" /></td>
                </tr>           
        <#}#>      
        </table>
    </script>
</asp:Content>
